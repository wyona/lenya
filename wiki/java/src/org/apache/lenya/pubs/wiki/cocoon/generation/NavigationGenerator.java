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
            File file = new File(new URL(this.resolver.resolveURI(super.source).getURI()).getFile());
            String filename = file.getAbsolutePath();

            short status = 1; //new CVSWrapper().updateFile(filename);
            String statusDescription = "EXCEPTION";
            switch (status) {
                case 1:
                    statusDescription = "UPDATED";
                    break;
                case 2:
                    statusDescription = "ADDED";
                    break;
                case 3:
                    statusDescription = "MODIFIED";
                    break;
                case 4:
                    statusDescription = "QUESTIONMARK";
                    break;
                case 5:
                    statusDescription = "UNMODIFIED";
                    break;
                default:
                    break;
            }

            // Return XML
            this.contentHandler.startDocument();
            AttributesImpl attr = new AttributesImpl();
            attr.addAttribute("", "status", "status", "CDATA", "" + status);
            attr.addAttribute("", "description", "description", "CDATA", "" + statusDescription);
            super.contentHandler.startElement(URI, "navigation", "navigation", attr);
            attr.clear();
            String data = filename;
            super.contentHandler.characters(data.toCharArray(), 0, data.length());
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
}
