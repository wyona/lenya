/*
 * Copyright 1999-2004 The Apache Software Foundation.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.cocoon.generation;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.ServiceSelector;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.excalibur.source.SourceNotFoundException;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.TimeStampValidity;
import org.apache.lenya.cms.cocoon.source.SourceUtil;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.lenya.cms.publication.DocumentFactory;
import org.apache.lenya.cms.publication.DocumentUtil;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.PublicationUtil;
import org.apache.lenya.cms.publication.URLInformation;
import org.apache.lenya.cms.repository.RepositoryException;
import org.apache.lenya.cms.repository.RepositoryUtil;
import org.apache.lenya.cms.repository.Session;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.util.ServletHelper;
import org.apache.lenya.xml.DocumentHelper;
import org.apache.xpath.XPathAPI;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * Blog entry generator
 */
public class FeedGenerator extends ServiceableGenerator {

    /** The URI of the namespace of this generator. */
    protected static final String URI = "http://apache.org/cocoon/blog/1.0";

    /** The namespace prefix for this namespace. */
    protected static final String PREFIX = "blog";

    /** Node and attribute names */
    protected static final String BLOG_NODE_NAME = "overview";

    protected static final String ENTRY_NODE_NAME = "entry";

    protected static final String DOCID_ATTR_NAME = "docid";

    protected static final String LASTMOD_ATTR_NAME = "lastModified";

    protected static final String YEAR_NODE_NAME = "year";

    protected static final String MONTH_NODE_NAME = "month";

    protected static final String DAY_NODE_NAME = "day";

    protected static final String ID_ATTR_NAME = "id";

    protected static final String URL_ATTR_NAME = "url";

    protected static final String TITLE_ATTR_NAME = "title";

    protected static boolean ascending;

    /**
     * Convenience object, so we don't need to create an AttributesImpl for
     * every element.
     */
    protected AttributesImpl attributes;

    /**
     * The Lenya-Area where the generator should work on
     */
    protected String area;

    /** Helper for lenya document retrival */
    protected String publicationId = null;

    protected String language = null;

    protected String docId = null;

    /** The corresponding lenya document */
    protected Document document;

    protected Publication pub;

    protected DocumentFactory map;

    /**
     * Request parameters
     */
    protected int year;

    protected int month;

    protected int day;

    /**
     * Recycle this component. All instance variables are set to
     * <code>null</code>.
     */
    public void recycle() {
        this.document = null;
        this.docId = null;
        this.language = null;
        this.area = null;
        this.publicationId = null;
        super.recycle();
    }

    /**
     * Serviceable
     * 
     * @param manager
     *            the ComponentManager
     * 
     * @throws ServiceException
     *             in case a component could not be found
     */
    public void service(ServiceManager manager) throws ServiceException {
        super.service(manager);
        this.attributes = new AttributesImpl();
    }

    /**
     * Set the request parameters. Must be called before the generate method.
     * 
     * @param resolver
     *            the SourceResolver object
     * @param objectModel
     *            a <code>Map</code> containing model object
     * @param src
     *            the source URI (ignored)
     * @param par
     *            configuration parameters
     * @throws RepositoryException 
     */
    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters par)
                    throws ProcessingException, SAXException, IOException {
        super.setup(resolver, objectModel, src, par);
        docId = par.getParameter("docid", null);
        if (this.docId == null) {
            throw new ProcessingException(
                            "The docid is not set! Please set like e.g. <map:parameter name='docid' value='{request-param:docid}'/>");
        }
        language = par.getParameter("lang", null);
        if (language == null)
            throw new ProcessingException("The 'lang' parameter is not set.");

        String param = par.getParameter("year", null);
        if (param != null)
            year = Integer.parseInt(param);
        else
            year = 0;
        param = par.getParameter("month", null);
        if (param != null)
            month = Integer.parseInt(param);
        else
            month = 0;
        param = par.getParameter("day", null);
        if (param != null)
            day = Integer.parseInt(param);
        else
            day = 0;
        ascending = par.getParameterAsBoolean("ascending", false);

        try {
            prepareLenyaDoc(objectModel);
        } catch (DocumentBuildException e) {
            throw new ProcessingException(src + " threw DocumentBuildException: " + e);
        } catch (RepositoryException e) {
          throw new ProcessingException(src + " threw RepositoryException: " + e);
        }

        // this.attributes = new AttributesImpl();
    }

    protected void prepareLenyaDoc(Map objectModel) throws DocumentBuildException,
                    ProcessingException, RepositoryException {

        Request request = ObjectModelHelper.getRequest(objectModel);
        Session session = RepositoryUtil.getSession(this.manager, request);

        try {
            this.pub = PublicationUtil.getPublication(this.manager, objectModel);
        } catch (PublicationException e) {
            throw new ProcessingException("Error geting publication id / area from page envelope",
                            e);
        }
        if (pub != null && pub.exists()) {
            this.publicationId = pub.getId();
            String url = ServletHelper.getWebappURI(request);
            this.area = new URLInformation(url).getArea();
            if (this.language == null) {
                this.language = pub.getDefaultLanguage();
            }
        }

        this.map = DocumentUtil.createDocumentIdentityMap(this.manager, session);
        this.document = map.get(pub, area, docId, language);
    }

    /**
     * Generate the unique key. This key must be unique inside the space of this
     * component.
     * 
     * @return The generated key hashes the src
     */
    public Serializable getKey() {
        return language + "$$" + docId;
    }

    /**
     * Generate the validity object.
     * 
     * @return The generated validity object or <code>null</code> if the
     *         component is currently not cacheable.
     */
    public SourceValidity getValidity() {
        long lastModified = document.getLastModified().getTime();
        return new TimeStampValidity(lastModified);
    }

    /**
     * Generate XML data.
     * 
     * @throws SAXException
     *             if an error occurs while outputting the document
     */
    public void generate() throws SAXException, ProcessingException {

        this.contentHandler.startDocument();
        this.contentHandler.startPrefixMapping(PREFIX, URI);
        attributes.clear();

        this.contentHandler.startElement(URI, BLOG_NODE_NAME, PREFIX + ':' + BLOG_NODE_NAME,
                        attributes);

        ServiceSelector selector = null;
        SiteManager siteManager = null;
        String pubHint = pub.getSiteManagerHint();
        try {

            selector = (ServiceSelector) this.manager.lookup(SiteManager.ROLE + "Selector");
            siteManager = (SiteManager) selector.select(pubHint);
            // NOTE: can be enhanced for performance by requesting only a
            // fragment of the site!
            Document[] docs = siteManager.getDocuments(map, pub, area);
            compute(docs);
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            if (selector != null) {
                if (siteManager != null) {
                    selector.release(siteManager);
                }
                this.manager.release(selector);
            }
        }

        this.contentHandler.endElement(URI, BLOG_NODE_NAME, PREFIX + ':' + BLOG_NODE_NAME);

        this.contentHandler.endPrefixMapping(PREFIX);
        this.contentHandler.endDocument();
    }

    private void compute(Document[] docs) throws NumberFormatException, SAXException,
                    ServiceException, SourceNotFoundException, ParserConfigurationException,
                    IOException, TransformerException {
        ArrayList filteredDocs = new ArrayList(1);
        for (int i = 0; i < docs.length; i++) {
            String currentDoc = docs[i].getId();
            if (currentDoc.startsWith(docId)) {
                currentDoc = currentDoc.substring(docId.length(), currentDoc.length());
                String[] patterns = currentDoc.split("/");
                if (patterns.length > 4) {
                    int eYear = 0;
                    int eMonth = 0;
                    int eDay = 0;
                    boolean add = false;

                    eYear = Integer.parseInt(patterns[1]);
                    eMonth = Integer.parseInt(patterns[2]);
                    eDay = Integer.parseInt(patterns[3]);
                    /* determine matching documents */
                    if (year > 0) {
                        if (year == eYear) {
                            if (month > 0) {
                                if (month == eMonth) {
                                    if (day > 0) {
                                        if (day == eDay) {
                                            /* add */
                                            add = true;
                                        }
                                    } else {
                                        /* add */
                                        add = true;
                                    }
                                }
                            } else {
                                if (day > 0) {
                                    if (day == eDay) {
                                        /* add */
                                        add = true;
                                    }
                                } else {
                                    /* add */
                                    add = true;
                                }
                            }
                        }
                    } else if (month > 0l) {
                        if (month == eMonth) {
                            if (day > 0) {
                                if (day == eDay) {
                                    /* add */
                                    add = true;
                                }
                            } else {
                                /* add */
                                add = true;
                            }
                        }
                    } else {
                        if (day > 0) {
                            if (day == eDay) {
                                /* add */
                                add = true;
                            }
                        } else {
                            /* add */
                            add = true;
                        }
                    }
                    if (add) {
                        filteredDocs.add((Object) docs[i]);
                    }
                }
            }
        }

        /* sort entries by year -> month -> day -> lastModified */
        Object[] sortedList = filteredDocs.toArray();
        Arrays.sort(sortedList, new Comparator() {
            public int compare(Object o1, Object o2) {
                Document d1, d2;
                int year1, month1, day1;
                int year2, month2, day2;

                d1 = (Document) o1;
                d2 = (Document) o2;
                String currentDoc1 = d1.getId();
                currentDoc1 = currentDoc1.substring(docId.length(), currentDoc1.length());
                String[] patterns = currentDoc1.split("/");

                year1 = Integer.parseInt(patterns[1]);
                month1 = Integer.parseInt(patterns[2]);
                day1 = Integer.parseInt(patterns[3]);

                String currentDoc2 = d2.getId();
                currentDoc2 = currentDoc2.substring(docId.length(), currentDoc2.length());
                patterns = currentDoc2.split("/");

                year2 = Integer.parseInt(patterns[1]);
                month2 = Integer.parseInt(patterns[2]);
                day2 = Integer.parseInt(patterns[3]);

                if (ascending) {
                    if (year1 > year2) {
                        return -1;
                    } else if (year1 == year2) {
                        if (month1 > month2) {
                            return -1;
                        } else if (month1 == month2) {
                            if (day1 > day2) {
                                return -1;
                            } else if (day1 == day2) {
                                /* newest first */
                                return d2.getLastModified().compareTo(d1.getLastModified());
                            } else {
                                return 1;
                            }
                        } else {
                            return 1;
                        }
                    } else {
                        return 1;
                    }
                } else {
                    if (year1 > year2) {
                        return 1;
                    } else if (year1 == year2) {
                        if (month1 > month2) {
                            return 1;
                        } else if (month1 == month2) {
                            if (day1 > day2) {
                                return 1;
                            } else if (day1 == day2) {
                                /* newest first */
                                return d2.getLastModified().compareTo(d1.getLastModified());
                            } else {
                                return -1;
                            }
                        } else {
                            return -1;
                        }
                    } else {
                        return -1;
                    }
                }
            }
        });

        /* group entries by year -> month -> day */
        /* works because the list is sorted =) */
        int currentYear = 0;
        int currentMonth = 0;
        int currentDay = 0;
        boolean yearOpen = false;
        boolean monthOpen = false;
        boolean dayOpen = false;
        for (int i = 0; i < sortedList.length; i++) {
            Document doc = ((Document) sortedList[i]);
            String currentDoc = doc.getId();
            currentDoc = currentDoc.substring(docId.length(), currentDoc.length());
            String[] patterns = currentDoc.split("/");
            int year = Integer.parseInt(patterns[1]);
            int month = Integer.parseInt(patterns[2]);
            int day = Integer.parseInt(patterns[3]);
            if (year != currentYear) {
                if (dayOpen) {
                    dayOpen = false;
                    this.contentHandler
                                    .endElement(URI, DAY_NODE_NAME, PREFIX + ':' + DAY_NODE_NAME);
                }
                if (monthOpen) {
                    monthOpen = false;
                    this.contentHandler.endElement(URI, MONTH_NODE_NAME, PREFIX + ':'
                                    + MONTH_NODE_NAME);
                }
                if (yearOpen) {
                    this.contentHandler.endElement(URI, YEAR_NODE_NAME, PREFIX + ':'
                                    + YEAR_NODE_NAME);
                }
                this.attributes.clear();
                attributes.addAttribute("", ID_ATTR_NAME, ID_ATTR_NAME, "CDATA", String
                                .valueOf(year));
                this.contentHandler.startElement(URI, YEAR_NODE_NAME,
                                PREFIX + ':' + YEAR_NODE_NAME, attributes);
                yearOpen = true;
                currentYear = year;
                currentMonth = 0;
                currentDay = 0;
            }
            if (month != currentMonth) {
                if (dayOpen) {
                    dayOpen = false;
                    this.contentHandler
                                    .endElement(URI, DAY_NODE_NAME, PREFIX + ':' + DAY_NODE_NAME);
                }
                if (monthOpen) {
                    this.contentHandler.endElement(URI, MONTH_NODE_NAME, PREFIX + ':'
                                    + MONTH_NODE_NAME);
                }
                this.attributes.clear();
                attributes.addAttribute("", ID_ATTR_NAME, ID_ATTR_NAME, "CDATA", String
                                .valueOf(month));
                this.contentHandler.startElement(URI, MONTH_NODE_NAME, PREFIX + ':'
                                + MONTH_NODE_NAME, attributes);
                monthOpen = true;
                currentMonth = month;
                currentDay = 0;
            }
            if (day != currentDay) {
                if (dayOpen) {
                    this.contentHandler
                                    .endElement(URI, DAY_NODE_NAME, PREFIX + ':' + DAY_NODE_NAME);
                }
                this.attributes.clear();
                attributes.addAttribute("", ID_ATTR_NAME, ID_ATTR_NAME, "CDATA", String
                                .valueOf(day));
                this.contentHandler.startElement(URI, DAY_NODE_NAME, PREFIX + ':' + DAY_NODE_NAME,
                                attributes);
                dayOpen = true;
                currentDay = day;
            }
            attributes.clear();
            attributes.addAttribute("", DOCID_ATTR_NAME, DOCID_ATTR_NAME, "CDATA", doc.getId());
            attributes.addAttribute("", URL_ATTR_NAME, URL_ATTR_NAME, "CDATA", doc
                            .getCanonicalWebappURL());
            org.w3c.dom.Document docDOM = SourceUtil.readDOM(doc.getSourceURI(), this.manager);
            Element parent = docDOM.getDocumentElement();
            Element element = (Element) XPathAPI.selectSingleNode(parent,
                            "/*[local-name() = 'entry']/*[local-name() = 'title']");
            Element elementSummary = (Element) XPathAPI.selectSingleNode(parent,
                            "/*[local-name() = 'entry']/*[local-name() = 'summary']");
            attributes.addAttribute("", TITLE_ATTR_NAME, TITLE_ATTR_NAME, "CDATA", DocumentHelper
                            .getSimpleElementText(element));
            attributes.addAttribute("", LASTMOD_ATTR_NAME, LASTMOD_ATTR_NAME, "CDATA", String
                            .valueOf(doc.getLastModified().getTime()));
            String summary = DocumentHelper.getSimpleElementText(elementSummary);
            this.contentHandler.startElement(URI, ENTRY_NODE_NAME, PREFIX + ':' + ENTRY_NODE_NAME,
                            attributes);
            this.contentHandler.ignorableWhitespace(summary.toCharArray(), 0, summary.length());
            this.contentHandler.endElement(URI, ENTRY_NODE_NAME, PREFIX + ':' + ENTRY_NODE_NAME);
        }

        if (dayOpen) {
            this.contentHandler.endElement(URI, DAY_NODE_NAME, PREFIX + ':' + DAY_NODE_NAME);
        }
        if (monthOpen) {
            this.contentHandler.endElement(URI, MONTH_NODE_NAME, PREFIX + ':' + MONTH_NODE_NAME);
        }
        if (yearOpen) {
            this.contentHandler.endElement(URI, YEAR_NODE_NAME, PREFIX + ':' + YEAR_NODE_NAME);
        }
    }
}
