package org.apache.lenya.svn;

import java.io.File;
import java.io.IOException;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;

import javax.xml.parsers.DocumentBuilder; 
import javax.xml.parsers.DocumentBuilderFactory;  
import javax.xml.parsers.FactoryConfigurationError;  
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.DOMException;

import org.xml.sax.SAXException;  
import org.xml.sax.SAXParseException;

/** updates sitetree.xml nodes with local svn changes **/
public class SitetreeUpdater {

  static Document document;
  
  /** receive sitetree.xml location, path of new file, title of new file updateSitetree */
  public static void updateSitetree (String sitetree, String file)
	  {
	      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	      
	      try {
	    	  
	    	  DocumentBuilder builder = factory.newDocumentBuilder();
	    	  document = builder.parse( new File(sitetree) );
	         
	          writeSitetree(document, sitetree);

	      } catch (SAXException sxe) {
	         // Error generated during parsing
	         Exception  x = sxe;
	         if (sxe.getException() != null)
	             x = sxe.getException();
	         x.printStackTrace();

	      } catch (ParserConfigurationException pce) {
	         // Parser with specified options can't be built
	         pce.printStackTrace();

	      } catch (IOException ioe) {
	         // I/O error
	         ioe.printStackTrace();
	      }

	  } 
  
  //This method writes a DOM document to a file
  public static void writeSitetree(Document doc, String filename) {
      try {
          // Prepare the DOM document for writing
          Source source = new DOMSource(doc);
  
          // Prepare the output file
          File file = new File(filename);
          Result result = new StreamResult(file);
  
          // Write the DOM document to the file
          Transformer xformer = TransformerFactory.newInstance().newTransformer();
          xformer.transform(source, result);
      } catch (TransformerConfigurationException e) {
      } catch (TransformerException e) {
      }
  }
  
}
