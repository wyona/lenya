/*
 * Copyright  1999-2004 The Apache Software Foundation
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
package org.apache.lenya.wiki.cms.usecases;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.io.Writer;

import org.apache.cocoon.components.ContextHelper;

import org.apache.cocoon.environment.Request;
import org.apache.excalibur.source.ModifiableSource;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceResolver;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentManager;
import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.util.DocumentHelper;
import org.apache.lenya.cms.repository.Node;
import org.apache.lenya.cms.repository.RepositoryException;
import org.apache.lenya.cms.site.SiteException;
import org.apache.lenya.cms.site.SiteUtil;
import org.apache.lenya.cms.usecase.DocumentUsecase;
import org.apache.lenya.cms.usecase.UsecaseException;

import org.wyona.wiki.ParseException;
import org.wyona.wiki.SimpleCharStream;
import org.wyona.wiki.SimpleNode;
import org.wyona.wiki.WikiParser;
import org.wyona.wiki.WikiParserTokenManager;

/**
 * Usecase to search a publication.
 * 
 * @version $Id: Search.java 157298 2005-03-12 23:41:26Z andreas $
 */
public class Edit extends DocumentUsecase {

    static boolean initialized = false;        
    WikiParser wikiParser;
    WikiParserTokenManager tokenManager;
    SimpleCharStream charStream;
    
    protected void initParameters() {
        super.initParameters();
        try {            
            StringBuffer buf = new StringBuffer();
            char[] cbuf = new char[1024];
            int rb;
            Request request = ContextHelper.getRequest(this.context);
            String encoding = request.getCharacterEncoding();
            Reader reader = new InputStreamReader(getSourceDocument().getRepositoryNode().getInputStream(), encoding);
            while ((rb=reader.read(cbuf)) != -1) { 
                buf.append(cbuf, buf.length(), rb);
            }
            reader.close();
            if (buf.length() == 0) {
                buf.append(' ');
            }
            setParameter("content", buf);            
        } catch (RepositoryException e) {
            this.addErrorMessage(e.getMessage());
        } catch (IOException e) {
            this.addErrorMessage(e.getMessage());
        }        
    }

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doCheckPreconditions()
     */
    protected void doCheckPreconditions() throws Exception {
        super.doCheckPreconditions();
        if (hasErrors()) {
            return;
        }
        if (!getSourceDocument().getArea().equals(Publication.AUTHORING_AREA)) {
            addErrorMessage("This usecase can only be invoked in the authoring area!");
        }
    }

    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#getNodesToLock()
     */
    protected Node[] getNodesToLock() throws UsecaseException {
        Node docNode = getSourceDocument().getRepositoryNode();
        Node siteNode;
        try {
            siteNode = SiteUtil.getSiteStructure(this.manager, getSourceDocument()).getRepositoryNode();
        } catch (SiteException e) {
            throw new UsecaseException(e);
        }
        Node[] nodes = { docNode, siteNode };
        return nodes;
    }

    public void advance() throws UsecaseException {
        super.advance();
        Request request = ContextHelper.getRequest(this.context);
        String content = getParameterAsString("content");                
        String encoding = request.getCharacterEncoding();        
        try {
            validate(content, "ISO-8859-1");
        } catch (Exception e) { 
            throw new UsecaseException(e);
        }        
    }
    
    /**
     * @see org.apache.lenya.cms.usecase.AbstractUsecase#doExecute()
     */
    protected void doExecute() throws Exception {
        super.doExecute();
        Request request = ContextHelper.getRequest(this.context);
        String content = getParameterAsString("content");                
        String encoding = request.getCharacterEncoding();        
        validate(content, encoding);                
        OutputStream wikiOut = getSourceDocument().getRepositoryNode().getOutputStream();
        Writer writer = new OutputStreamWriter(wikiOut, "ISO-8859-1");
        writer.write(content);
        writer.close();
    }
    
    protected void validate(String content, String encoding) throws Exception {                     
        InputStream wikiIs = new ByteArrayInputStream(content.getBytes(encoding));
        charStream = new SimpleCharStream(new InputStreamReader(wikiIs, encoding));
        tokenManager = new WikiParserTokenManager(charStream); 
        wikiParser = new WikiParser(tokenManager); 
        wikiParser.WikiBody();
    }

}
