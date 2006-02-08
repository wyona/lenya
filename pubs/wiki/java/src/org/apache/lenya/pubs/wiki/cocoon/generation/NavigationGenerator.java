package org.apache.lenya.pubs.wiki.cocoon.generation;

import org.apache.avalon.framework.component.Component;

import org.apache.cocoon.generation.ComposerGenerator;

import org.apache.excalibur.xml.sax.SAXParser;

import java.io.File;
import java.net.URL;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 *
 */
public class NavigationGenerator extends ComposerGenerator {

    // The URI of the namespace of this generator
    private String URI = "";

    /**
     * Generate XML data.
     */
    public void generate() throws SAXException {

        SAXParser parser = null;
        try {
            //File file = new File(new URL(this.resolver.resolveURI(super.source).getURI()).getFile());
            //String filename = file.getAbsolutePath();
            //getLogger().debug("File: " + filename);

            File sitemapDir = new File(new URL(this.resolver.resolveURI("").getURI()).getFile());
            getLogger().debug("Sitemap: " + sitemapDir);
            getLogger().debug("Source: " + super.source);

            // Return XML
            this.contentHandler.startDocument();
            AttributesImpl attr = new AttributesImpl();
            super.contentHandler.startElement(URI, "navigation", "navigation", attr);
            attr.clear();
            super.contentHandler.startElement(URI, "bread-crumbs", "bread-crumbs", attr);
            attr.clear();

            String[] nodes = super.source.toString().split("/");
            for (int i = 0;i < nodes.length;i++) {
                attr.addAttribute("", "id", "status", "CDATA", "");
                attr.addAttribute("", "path", "description", "CDATA", getPath(nodes.length - i - 1));
                super.contentHandler.startElement(URI, "crumb", "crumb", attr);
                attr.clear();
                String label = null;
                if (i == 0) {
                    label = "Home";
                } else {
                    label = nodes[i];
                }
                super.contentHandler.characters(label.toCharArray(), 0, label.length());
                super.contentHandler.endElement(URI, "crumb", "crumb");
            }
            super.contentHandler.endElement(URI, "bread-crumbs", "bread-crumbs");
            super.contentHandler.endElement(URI, "navigation", "navigation");
            this.contentHandler.endDocument();


/*
            byte[] sresponse = new byte[1024];
            InputSource input = new InputSource(new ByteArrayInputStream(sresponse));
            parser = (SAXParser) this.manager.lookup(SAXParser.ROLE);
            parser.parse(input, this.xmlConsumer);
*/
        } catch (Exception e) {
            this.contentHandler.startDocument();
            AttributesImpl attr = new AttributesImpl();
            super.contentHandler.startElement(URI, "navigation-exception", "navigation-exception", attr);
            String data = ".generate(): " + e;
            super.contentHandler.characters(data.toCharArray(), 0, data.length());
            super.contentHandler.endElement(URI, "navigation-exception", "navigation-exception");
            attr.clear();
            this.contentHandler.endDocument();

            getLogger().error(".generate():", e);
        } finally {
            this.manager.release((Component) parser);
        }
    }

    /**
     *
     */
    private String getPath(int n) {
        String path = "";
        for (int i = 0;i < n;i++) {
            path = path + "../";
        }
        return path;
    }
}
