package org.apache.lenya.svn;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;

/** writes the content of index_en.xml.meta in a File */
public class MetaDataWriter {

  String resourceType = "xhtml";
  String contentType = "xml";
  String title = "SETME";
  String creator = "lenya";
  String subject = "";
  String description = "";
  String publisher = "SETME";
  String date = "2006-01-31";

  /**
   * @param file
   */
  void addMetaFile(File file) {

    PrintWriter out = null; 
    try {
      out = new PrintWriter(
          new BufferedWriter(new FileWriter(file)));
      writeMetaData(out);
      out.close();
    } catch (Exception e) {
      throw new RuntimeException();
    } finally {
      out.close();      
    }
  }

  public void addMetaFile(File file_, String ressourceType_, String title_, String publisher_) {
    this.resourceType=  removeNonAlphanumeric(ressourceType_);
    this.title=  removeNonAlphanumeric(title_);
    this.publisher=  removeNonAlphanumeric(publisher_);
    addMetaFile(file_);
  }

  /** based on a generic index_en.xml.meta file */
  private void writeMetaData(PrintWriter out) {

    out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            + "        <!--\n"
            + "          Copyright 1999-2006 The Apache Software Foundation\n\n"
            + "          Licensed under the Apache License, Version 2.0 (the \"License\");\n"
            + "          you may not use this file except in compliance with the License.\n"
            + "          You may obtain a copy of the License at\n\n"
            + "              http://www.apache.org/licenses/LICENSE-2.0\n\n"
            + "          Unless required by applicable law or agreed to in writing, software\n"
            + "          distributed under the License is distributed on an \"AS IS\" BASIS,\n"
            + "          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n"
            + "          See the License for the specific language governing permissions and\n"
            + "          limitations under the License.\n"
            + "        -->\n"
            + "        <lenya:document xmlns:lenya=\"http://apache.org/cocoon/lenya/page-envelope/1.0\">\n"
            + "        <lenya:meta>\n"
            + "        <lenya:internal>\n"
            + "        <lenya:resourceType>"
            + resourceType
            + "</lenya:resourceType>\n"
            + "        <lenya:contentType>"
            + contentType
            + "</lenya:contentType>\n"
            + "        </lenya:internal>\n"
            + "        <lenya:dc>\n"
            + "                <dc:title xmlns:dc=\"http://purl.org/dc/elements/1.1/\">"
            + title
            + "</dc:title>\n"
            + "                <dc:creator xmlns:dc=\"http://purl.org/dc/elements/1.1/\">"
            + creator
            + "</dc:creator>\n"
            + "                <dc:subject xmlns:dc=\"http://purl.org/dc/elements/1.1/\">"
            + subject
            + "</dc:subject>\n"
            + "                <dc:description xmlns:dc=\"http://purl.org/dc/elements/1.1/\">"
            + description
            + "</dc:description>\n"
            + "                <dc:publisher xmlns:dc=\"http://purl.org/dc/elements/1.1/\">"
            + publisher
            + "</dc:publisher>\n"
            + "                <dc:date xmlns:dc=\"http://purl.org/dc/elements/1.1/\">"
            + date
            + "</dc:date>\n"
            + "                <dc:type xmlns:dc=\"http://purl.org/dc/elements/1.1/\" />\n"
            + "                <dc:format xmlns:dc=\"http://purl.org/dc/elements/1.1/\" />\n"
            + "                <dc:identifier xmlns:dc=\"http://purl.org/dc/elements/1.1/\" />\n"
            + "                <dc:source xmlns:dc=\"http://purl.org/dc/elements/1.1/\" />\n"
            + "                <dc:language xmlns:dc=\"http://purl.org/dc/elements/1.1/\">en</dc:language>\n"
            + "                <dc:relation xmlns:dc=\"http://purl.org/dc/elements/1.1/\" />\n"
            + "                <dc:coverage xmlns:dc=\"http://purl.org/dc/elements/1.1/\" />\n"
            + "                <dc:rights xmlns:dc=\"http://purl.org/dc/elements/1.1/\">All rights reserved</dc:rights>\n"
            + "        </lenya:dc>\n" + "        </lenya:meta>\n"
            + "        </lenya:document>");
  }
  
  /**
   * Remove occurences of non-alphanumeric characters.
   */
  public static String removeNonAlphanumeric(String str) {
    StringBuffer ret = new StringBuffer(str.length());
    char[] testChars = str.toCharArray();
    for (int i = 0; i < testChars.length; i++) {
      if (Character.isLetterOrDigit(testChars[i])) {
        ret.append(testChars[i]);
      } else {
        // replace with " "
        ret.append(" ");
      }
    }
    return ret.toString();
  }
 
}
