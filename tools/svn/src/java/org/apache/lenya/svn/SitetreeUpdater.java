package org.apache.lenya.svn;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.ListIterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/** updates sitetree.xml nodes with local svn changes **/
public class SitetreeUpdater {

  static Document document;
  static boolean debug;
  
  /** receive sitetree.xml location, path of new file, title of new file updateSitetree */
  public static void updateSitetree (String pathToSitetree, ArrayList newNodes, boolean debug_)
	  {
	      DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
          debug = debug_;
          
	      try {
	    	  
	    	  DocumentBuilder builder = factory.newDocumentBuilder();
	    	  document = builder.parse( new File(pathToSitetree) );

              ListIterator it = newNodes.listIterator();
              while (it.hasNext()) {
                addNode((String)it.next());
              }
              
	          writeSitetree(document, pathToSitetree);

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
  
  /**
   * @param newNode
   */
  private static void addNode(String newNode) {
    
    String [] nodePath = newNode.split("/");
    Element root = document.getDocumentElement();

    String newNodeName = nodePath[nodePath.length - 2];
    if (debug) {
      System.err.println("newNode " + newNode);
      System.err.println("newNodeName " + newNodeName);
      System.err.println("nodepathlengti " + nodePath.length);
    }
    
    // is the new node a child of the root node ?
    if (nodePath.length < 4) {
      createNode(root, newNodeName);
      
    } else {
      
      // the name of the parent 
      String newNodeParentName = nodePath[nodePath.length - 3];

      //  Get a list of all elements in the document
      NodeList list = document.getElementsByTagName("*");
      for (int i=0; i<list.getLength(); i++) {

        Element element = (Element)list.item(i);
        
        if (debug) {
          System.err.println(i+ ": " + element.getNodeName().equals("node"));
          System.err.println(element.getAttributeNode("id"));
        }
        
        if (element.getNodeName().equals("node") && element.getAttributeNode("id").getValue().equals(newNodeParentName)){
          createNode(element, newNodeName);
          break;
        }
      }
    }
  }

  private static void createNode(Element parent, String newNodeName) {
    if (debug) {
      System.err.println("**** createNode ");
      System.err.println("newNodeName " + newNodeName);
      System.err.println("root " + parent);
    }
    
    Element newNode = document.createElement("node");
    newNode.setAttribute("id", newNodeName);
    parent.appendChild(newNode);

    Element newNodeLabel = document.createElement("label");
    newNodeLabel.setAttribute("xml:lang", "en");
    newNodeLabel.appendChild(document.createTextNode(newNodeName));
    newNode.appendChild(newNodeLabel);
  }

  //This method writes a DOM document to a file
  private static void writeSitetree(Document doc, String filename) {
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
