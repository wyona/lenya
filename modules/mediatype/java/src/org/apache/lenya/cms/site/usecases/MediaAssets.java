/*
 * Copyright  1999-2006 The Apache Software Foundation
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

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.imageio.ImageIO;

import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceSelector;
import org.apache.cocoon.servlet.multipart.Part;
import org.apache.commons.io.IOUtils;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.excalibur.source.ModifiableSource;
import org.apache.excalibur.source.SourceResolver;
import org.apache.lenya.cms.cocoon.source.SourceUtil;
import org.apache.lenya.cms.metadata.LenyaMetaData;
import org.apache.lenya.cms.metadata.MetaData;
import org.apache.lenya.cms.publication.DefaultResourcesManager;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentException;
import org.apache.lenya.cms.publication.ResourceType;
import org.apache.lenya.cms.usecase.UsecaseException;

public class MediaAssets extends CreateDocument {
    // A media type document is an aggregation of different files.
    // The describtion file has following default extension
    public static final String MEDIA_FILE_EXTENSION="xml";
    /**
     * Validates the request parameters.
     * 
     * @throws UsecaseException if an error occurs.
     */
    void validate() throws UsecaseException {
        String title = getParameterAsString("title");

        if (title.length() == 0) {
            addErrorMessage("Please enter a title.");
        }
    }

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doCheckExecutionConditions()
     */
    protected void doCheckExecutionConditions() throws Exception {
        validate();
    }

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
        super.doExecute();
        addAsset();
        addDoc();
    }

    private void addDoc() throws Exception {
    	ResourceType resourceType = null;
    	ServiceSelector selector = null;
    	SourceResolver resolver = null;
    	selector = (ServiceSelector) this.manager.lookup(ResourceType.ROLE + "Selector");
    	resolver = (SourceResolver) this.manager.lookup(SourceResolver.ROLE);
        resourceType = (ResourceType) selector.select(getDocumentTypeName());
    	Document document = getNewDocument();
		String uri= document.getSourceURI();
		int lastDotIndex = uri.lastIndexOf(".");
        String destination = uri.substring(0,lastDotIndex).concat("."+MEDIA_FILE_EXTENSION);
        String sourceUri=resourceType.getSampleURI();
        try {
			SourceUtil.copy(resolver, sourceUri, destination);
		} catch (Exception e) {
			throw new Exception(e);
		}finally {
            if (selector != null) {
                if (resourceType != null) {
                    selector.release(resourceType);
                }
            }
            this.manager.release(selector);
            this.manager.release(resolver);
        }
	}

	/**
     * Adds an asset. If asset upload is not enabled, an error message is added.
     * @throws IOException 
     * @throws ServiceException 
     * @throws DocumentException 
     */
    protected void addAsset() throws ServiceException, IOException, DocumentException {

        if (getLogger().isDebugEnabled())
            getLogger().debug("Assets::addAsset() called");

        Part file = getPart("file");

        if (file.isRejected()) {
            String[] params = { Integer.toString(file.getSize()) };
            addErrorMessage("upload-size-exceeded", params);
        } else {
            addAsset(file);
        }
    }

    /**
     * Adds an asset.
     * 
     * @param file The part.
     * @throws IOException 
     * @throws ServiceException 
     * @throws DocumentException 
     */
    protected void addAsset(Part file) throws IOException, ServiceException, DocumentException {
        Document document = getNewDocument();
        MetaData customMeta = null;

        SourceResolver resolver = null;
        ModifiableSource source = null;
        OutputStream destOutputStream = null;
        InputStream inputStream = file.getInputStream();
        try {
            customMeta = document.getMetaDataManager().getCustomMetaData();
            addAssetMeta(file,customMeta);
            resolver = (SourceResolver) this.manager.lookup(SourceResolver.ROLE);
            source = (ModifiableSource) resolver.resolveURI(document.getSourceURI());
            destOutputStream = source.getOutputStream();

            final ByteArrayOutputStream sourceBos = new ByteArrayOutputStream();
            IOUtils.copy(inputStream, sourceBos);
            IOUtils.write(sourceBos.toByteArray(), destOutputStream);
        } finally {
            if (destOutputStream != null) {
                destOutputStream.flush();
                destOutputStream.close();
            }
            if (inputStream != null) {
                inputStream.close();
            }
        }

        if (getLogger().isDebugEnabled())
            getLogger().debug("Assets::addAsset() done.");
    }

    protected String getSourceExtension() {
        String extension = "";
        
        Part file = getPart("file");
        String fileName = file.getFileName();
        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex > -1) {
            extension = fileName.substring(lastDotIndex + 1);
        }
        else {
            addErrorMessage("Please upload a file with an extension.");
        }
        return extension;
    }

    protected void addAssetMeta (Part part, MetaData customMeta) throws DocumentException, IOException{
        String fileName = part.getFileName();
        String mimeType = part.getMimeType();
        int fileSize = part.getSize();
        if(customMeta!=null){
            customMeta.addValue("media-filename", fileName);
            customMeta.addValue("media-format", mimeType);
            customMeta.addValue("media-extent", Integer.toString(fileSize));
          }
        if (DefaultResourcesManager.canReadMimeType(mimeType)) {
            BufferedImage input = ImageIO.read(part.getInputStream());
            String width = Integer.toString(input.getWidth());
            String height = Integer.toString(input.getHeight());
            if(customMeta!=null){
              customMeta.addValue("media-"+LenyaMetaData.ELEMENTE_HEIGHT, height);
              customMeta.addValue("media-"+LenyaMetaData.ELEMENT_WIDTH, width);
            }
        }
    }
}
