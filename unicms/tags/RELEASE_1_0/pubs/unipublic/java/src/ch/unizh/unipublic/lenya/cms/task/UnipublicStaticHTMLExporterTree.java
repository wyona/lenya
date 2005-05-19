/*
 * <License>
 * The Apache Software License
 *
 * Copyright (c) 2002 lenya. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or
 *    other materials provided with the distribution.
 *
 * 3. All advertising materials mentioning features or use of this software must
 *    display the following acknowledgment: "This product includes software developed
 *    by lenya (http://www.lenya.org)"
 *
 * 4. The name "lenya" must not be used to endorse or promote products derived from
 *    this software without prior written permission. For written permission, please
 *    contact contact@lenya.org
 *
 * 5. Products derived from this software may not be called "lenya" nor may "lenya"
 *    appear in their names without prior written permission of lenya.
 *
 * 6. Redistributions of any form whatsoever must retain the following acknowledgment:
 *    "This product includes software developed by lenya (http://www.lenya.org)"
 *
 * THIS SOFTWARE IS PROVIDED BY lenya "AS IS" WITHOUT ANY WARRANTY EXPRESS OR IMPLIED,
 * INCLUDING THE WARRANTY OF NON-INFRINGEMENT AND THE IMPLIED WARRANTIES OF MERCHANTI-
 * BILITY AND FITNESS FOR A PARTICULAR PURPOSE. lenya WILL NOT BE LIABLE FOR ANY DAMAGES
 * SUFFERED BY YOU AS A RESULT OF USING THIS SOFTWARE. IN NO EVENT WILL lenya BE LIABLE
 * FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR LOST PROFITS EVEN IF lenya HAS
 * BEEN ADVISED OF THE POSSIBILITY OF THEIR OCCURRENCE. lenya WILL NOT BE LIABLE FOR ANY
 * THIRD PARTY CLAIMS AGAINST YOU.
 *
 * Lenya includes software developed by the Apache Software Foundation, W3C,
 * DOM4J Project, BitfluxEditor and Xopus.
 * </License>
 */
package ch.unizh.unipublic.lenya.cms.task;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;

import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationException;
import org.apache.lenya.cms.publication.Resource;
import org.apache.lenya.cms.publication.Version;
import org.apache.lenya.cms.publication.util.OrderedResourceSet;
import org.apache.lenya.cms.publication.util.ResourceVisitor;
import org.apache.lenya.cms.publishing.PublishingEnvironment;
import org.apache.lenya.cms.site.SiteManager;
import org.apache.lenya.cms.task.ExecutionException;
import org.apache.log4j.Category;

import ch.unizh.lenya.cms.task.ResourceTask;

/**
 * Download the HTML and save it of a tree of documents. Correspond to the StaticHTMLExporter
 * 
 * @author <a href="mailto:ediths@apache.org">Edith Chevrier</a>
 */

public class UnipublicStaticHTMLExporterTree extends ResourceTask implements ResourceVisitor {

    private static final Category log = Category.getInstance(UnipublicStaticHTMLExporterTree.class);
    public static final String PARAMETER_LANGUAGE = "document-language";

    /**
     * @see org.apache.lenya.cms.task.Task#execute(java.lang.String)
     */
    public void execute(String servletContextPath) throws ExecutionException {
        try {
            PublishingEnvironment environment = this.getPublication().getEnvironment();
            Parameters taskParameters = new Parameters();
            // read default parameters from PublishingEnvironment
            taskParameters.setParameter(PublishingEnvironment.PARAMETER_EXPORT_PATH,
                environment.getExportDirectory());
            taskParameters.setParameter(PublishingEnvironment.PARAMETER_SUBSTITUTE_REGEXP,
                environment.getSubstituteExpression());
            taskParameters.setParameter(PublishingEnvironment.PARAMETER_SUBSTITUTE_REPLACEMENT,
                environment.getSubstituteReplacement());

            taskParameters.merge(getParameters());
            parameterize(taskParameters);

            Resource resource = getResource();

            if (!checkPreconditions(resource)) {
                setResult(FAILURE);
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("Can execute task: parent is published.");
                }
                export(resource);
                setResult(SUCCESS);
            }

        } catch (ExecutionException e) {
            throw e;
        } catch (Exception e) {
            throw new ExecutionException(e);
        }
    }

    /**
     * Checks if the preconditions are complied.
     * @param resource The root resource of the tree to publish. 
     * @return a boolean.
     * @throws PublicationException when something went wrong.
     * @throws ExecutionException when something went wrong.
     * @throws DocumentException when something went wrong.
     */
   protected boolean checkPreconditions(Resource resource) 
       throws ParameterException, ExecutionException, PublicationException {

        boolean OK = true;

        Version liveVersion = getVersion(resource, Publication.LIVE_AREA, getLanguage());
        if (log.isDebugEnabled()) {
          log.debug("Version: [" + liveVersion + "]");
        }

        if (!liveVersion.getDocument().exists()) {
          OK = false;
          if (log.isDebugEnabled()) {
              log.debug(
                "Cannot execute task: the live document doesn't exist");
          }
        }
        return OK;
    }

    /** 
     * Downloads and saves the HTML of the documents' subtree of this resource.
     * @param resource The resource.
     * @throws PublicationException when something went wrong.
     */
    protected void export(Resource resource) throws PublicationException {
        if (log.isDebugEnabled()) {
            log.debug("export subtree below resource [" + resource + "]");
        }
      
        SiteManager manager = resource.getPublicationWrapper().getSiteManager();
        Resource[] ancestors = manager.getRequiringResources(resource, Publication.AUTHORING_AREA);

        OrderedResourceSet set = new OrderedResourceSet(ancestors);
        set.add(resource);
        set.visitAscending(this);

        if (log.isDebugEnabled()) {
            log.debug("Export completed.");
        }

    }

    /**
     * @see org.apache.lenya.cms.publication.util.ResourceVisitor#visitDocument(org.apache.lenya.cms.publication.Resource)
     */
    public void visitDocument(Resource resource) throws PublicationException {
        if (log.isDebugEnabled()) {
            log.debug("Visiting resource [" + resource + "]");
        }
        try {
            if (!checkPreconditions(resource)) {
                setResult(FAILURE);
            } else {
                if (log.isDebugEnabled()) {
                    log.debug("Can export all language versions: the preconditions are met");
                }
                exportAllLanguageVersions(resource);
                setResult(SUCCESS);
            }
        } catch (PublicationException e) {
            throw e;
        } catch (Exception e) {
            throw new PublicationException(e);
        }
    }

    /**
     * Exports all published existing language versions of a resource.
     * @param resource The resource.
     * @throws ExecutionException when something went wrong.
     * @throws PublicationException when something went wrong.
     * @throws ParameterException when something went wrong.
     */
    protected void exportAllLanguageVersions(Resource resource) 
        throws ParameterException, ExecutionException, PublicationException {

        if (log.isDebugEnabled()) {
            log.debug("exportAllLanguageVersions[" + resource + "]");
        }
        String[] languages = getPublication().getLanguages();
        for (int i = 0; i < languages.length; i++) {
            Version liveVersion = getVersion(resource, Publication.LIVE_AREA, languages[i]);
            if (liveVersion.getDocument().exists()) {
                export(resource, languages[i]);
            }
        }

    }

    /**
     * Exports a published language version of a resource.
     * @param resource The resource.
     * @param language The language.
     * @throws ExecutionException when something went wrong.
     */
    protected void export(Resource resource, String language) throws ExecutionException {
        
        if (log.isDebugEnabled()) {
            log.debug("export resource [" + resource + "]");
        }

        try {
            String exportDirectory = getExportDirectory();
            if (log.isDebugEnabled()) {
                log.debug(".export(): Export directory: " + exportDirectory);
              }

            org.apache.lenya.net.WGet wget = new org.apache.lenya.net.WGet();
            wget.setDirectoryPrefix(exportDirectory);

            String fullServerURI = getServerURL();
            
            Version liveVersion = getVersion(resource,
                    Publication.LIVE_AREA, language);
            String documentUrl = liveVersion.getDocument().getCompleteURL();
            String uri = this.getParameters().getParameter(PARAMETER_CONTEXT_PREFIX) + documentUrl; 
            
            URL url = new URL(fullServerURI + uri);
            if (log.isDebugEnabled()) {
              log.debug(".export(): Export static HTML: " + url);
            }  

            wget.download(url, getSubstituteExpression(), getSubstituteReplacement());
        } catch (Exception e) {
            throw new ExecutionException(e);
        }
        
    }

    /**
     * Returns the language.
     * @return A string.
     * @throws ParameterException when the parameter is not present.
     * @throws ExecutionException when the language is not valid.
     */
    protected String getLanguage() throws ParameterException, ExecutionException {
        String language = getParameters().getParameter(PARAMETER_LANGUAGE);

        String[] languages = getPublication().getLanguages();
        if (!Arrays.asList(languages).contains(language)) {
            throw new ExecutionException("The language [" + language + "] is not valid!");
        }

        return language;
    }

    /** 
     * Returns the server URL.
     * @return A string.
     * @throws ParameterException
     * @throws MalformedURLException
     */
    protected String getServerURL() throws ParameterException, MalformedURLException {
        URL serverURI = new URL(getParameters().getParameter(PARAMETER_SERVER_URI));
        int serverPort = getParameters().getParameterAsInteger(PARAMETER_SERVER_PORT);  
        String fullServerURI = serverURI + ":" + serverPort;
        return fullServerURI;
    }
    
    /** 
     * Returns The subtitute replacement parameter 
     * @return A string.
     * @throws ParameterException when something went wrong.
     */
    protected String getSubstituteReplacement() throws ParameterException {
      String substituteReplacement =getParameters().getParameter(PublishingEnvironment.PARAMETER_SUBSTITUTE_REPLACEMENT);
      return substituteReplacement;
    }
    /**
     * Returns the substitute expression parameter.
     * @return A string.
     * @throws ParameterException when something went wrong.
     */
    protected String getSubstituteExpression() throws ParameterException {
      String substituteExpression = getParameters().getParameter(PublishingEnvironment.PARAMETER_SUBSTITUTE_REGEXP);
      return substituteExpression;
    }

    /**
     * Returns the export directory.
     * @return A string.
     * @throws ParameterException when something went wrong.
     * @throws ExecutionException when something went wrong.
     */
    protected String getExportDirectory() throws ParameterException, ExecutionException {
        String exportDirectory = getPublication().getDirectory().getAbsolutePath() + File.separator + getParameters().getParameter(PublishingEnvironment.PARAMETER_EXPORT_PATH);
        return exportDirectory;
      }
}
