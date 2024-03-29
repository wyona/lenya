/*
 * Copyright  1999-2005 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package org.apache.lenya.cms.site.usecases;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.cocoon.servlet.multipart.Part;
import org.apache.excalibur.source.ModifiableSource;
import org.apache.excalibur.source.SourceResolver;
import org.apache.lenya.cms.cocoon.source.RepositorySource;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.repository.Node;
import org.apache.lenya.cms.usecase.DocumentUsecase;

/**
 * Usecase to create a document.
 * 
 * @version $Id: CreateDocument.java 379098 2006-02-20 11:35:10Z andreas $
 */
public class UploadWordDocument extends DocumentUsecase {

    protected static final String DOC_EXTENSION = ".doc";

    protected static final String DOC_MIME_TYPE = "application/msword";

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#initParameters()
     */
    protected void initParameters() {
        super.initParameters();
    }

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doExecute()
     */
    protected void doExecute() throws Exception {
        if (getLogger().isDebugEnabled())
            getLogger().debug("DOC::uploadDOC() called");
        Document source = getSourceDocument();
        String destination = source.getSourceURI();
        if (source.getSourceExtension().equals("xml")) {
            destination = destination.substring(0, destination.lastIndexOf(".xml")) + DOC_EXTENSION;
        }

        Part file = getPart("file");
        String mimeType = file.getMimeType();

        if (file.isRejected()) {
            String[] params = { Integer.toString(file.getSize()) };
            addErrorMessage("upload-size-exceeded", params);
        } else if (DOC_MIME_TYPE.equals(mimeType)){
            saveResource(destination, file);
        } else {
            addErrorMessage("The mime type of the document you want to upload does not match the mime type: \""+DOC_MIME_TYPE+"\"");
        }

    }

    /**
     * Saves the resource to a file.
     * 
     * @param destination
     *            The destination to write the file.
     * @param part
     *            The part of the multipart request.
     * @throws IOException
     *             if an error occurs.
     */
    protected void saveResource(String destination, Part part)
                    throws IOException {
        OutputStream out = null;
        InputStream in = null;

        SourceResolver resolver = null;
        ModifiableSource source = null;

        try {
            resolver = (SourceResolver) this.manager
                            .lookup(SourceResolver.ROLE);
            source = (ModifiableSource) resolver.resolveURI(destination);
            // now that the source is determined, lock involved nodes
            Node node = getRepositoryNode(destination);
            node.lock();

            byte[] buf = new byte[4096];
            out = source.getOutputStream();
            in = part.getInputStream();
            int read = in.read(buf);

            while (read > 0) {
                out.write(buf, 0, read);
                read = in.read(buf);
            }
        } catch (final FileNotFoundException e) {
            getLogger().error("file not found" + e.toString());
            throw new IOException(e.toString());
        } catch (IOException e) {
            getLogger().error("IO error " + e.toString());
            throw new IOException(e.toString());
        } catch (Exception e) {
            getLogger().error("Exception" + e.toString());
            throw new IOException(e.toString());
        } finally {
            if (in != null) {
                in.close();
            }
            if (out != null) {
                out.flush();
                out.close();
            }

            if (resolver != null) {
                if (source != null) {
                    resolver.release(source);
                }
                this.manager.release(resolver);
            }
        }
    }
    
    /**
     * @return The repository node that represents the document identified by the destination string.
     */
    public Node getRepositoryNode(String destination) {
        Node node = null;
        SourceResolver resolver = null;
        RepositorySource documentSource = null;
        try {
            resolver = (SourceResolver) this.manager
                            .lookup(SourceResolver.ROLE);
            documentSource = (RepositorySource) resolver
                            .resolveURI(destination);
            node = documentSource.getNode();
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            if (resolver != null) {
                if (documentSource != null) {
                    resolver.release(documentSource);
                }
                this.manager.release(resolver);
            }
        }
        return node;
    }

}
