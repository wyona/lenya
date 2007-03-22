/* $Id: UnizhRedirectAction.java 2006-03-27 ch.unizh.mike $
<License>

 ============================================================================
                   The Apache Software License, Version 1.1
 ============================================================================

 Copyright (C) 1999-2003 The Apache Software Foundation. All rights reserved.

 Redistribution and use in source and binary forms, with or without modifica-
 tion, are permitted provided that the following conditions are met:

 1. Redistributions of  source code must  retain the above copyright  notice,
    this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. The end-user documentation included with the redistribution, if any, must
    include  the following  acknowledgment:  "This product includes  software
    developed  by the  Apache Software Foundation  (http://www.apache.org/)."
    Alternately, this  acknowledgment may  appear in the software itself,  if
    and wherever such third-party acknowledgments normally appear.

 4. The names "Apache Lenya" and  "Apache Software Foundation"  must  not  be
    used to  endorse or promote  products derived from  this software without
    prior written permission. For written permission, please contact
    apache@apache.org.

 5. Products  derived from this software may not  be called "Apache", nor may
    "Apache" appear  in their name,  without prior written permission  of the
    Apache Software Foundation.

 THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS  FOR A PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN NO  EVENT SHALL  THE
 APACHE SOFTWARE  FOUNDATION  OR ITS CONTRIBUTORS  BE LIABLE FOR  ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL  DAMAGES (INCLU-
 DING, BUT NOT LIMITED TO, PROCUREMENT  OF SUBSTITUTE GOODS OR SERVICES; LOSS
 OF USE, DATA, OR  PROFITS; OR BUSINESS  INTERRUPTION)  HOWEVER CAUSED AND ON
 ANY  THEORY OF LIABILITY,  WHETHER  IN CONTRACT,  STRICT LIABILITY,  OR TORT
 (INCLUDING  NEGLIGENCE OR  OTHERWISE) ARISING IN  ANY WAY OUT OF THE  USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 This software  consists of voluntary contributions made  by many individuals
 on  behalf of the Apache Software  Foundation and was  originally created by
 Michael Wechner <michi@apache.org>. For more information on the Apache Soft-
 ware Foundation, please see <http://www.apache.org/>.

 Lenya includes software developed by the Apache Software Foundation, W3C,
 DOM4J Project, BitfluxEditor, Xopus, and WebSHPINX.
</License>
*/
package ch.unizh.lenya.cms.cocoon.acting;

import org.apache.avalon.framework.parameters.Parameters;

import org.apache.cocoon.acting.AbstractAction;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;

import org.apache.excalibur.source.Source;

import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.PageEnvelope;
import org.apache.lenya.cms.publication.PageEnvelopeFactory;
import org.apache.lenya.cms.publication.Publication;
import ch.unizh.lenya.cms.publication.UnizhImpl;

import java.util.HashMap;
import java.util.Map;

/**
 * Returns the attribute href specified in <unizh:redirect-to>
 * of the current document. Returns null object if no attribute is specified
 * or if the current document is not of type "redirect".
 * 
 * @author <a href="mailto:michael.trindler@id.uzh.ch">Michael Trindler</a>
 */
public class UnizhRedirectAction extends AbstractAction {

    /**
     * @see org.apache.cocoon.acting.Action#act(org.apache.cocoon.environment.Redirector, org.apache.cocoon.environment.SourceResolver, java.util.Map, java.lang.String, org.apache.avalon.framework.parameters.Parameters)
     */
    public Map act(
        Redirector redirector,
        SourceResolver resolver,
        Map objectModel,
        String source,
        Parameters parameters)
        throws Exception {

        String value = null;
        Request request = ObjectModelHelper.getRequest(objectModel);
        String context = request.getContextPath();
        String uri = request.getRequestURI();

        try {
            value = "";
            PageEnvelope envelope = PageEnvelopeFactory.getInstance().getPageEnvelope(objectModel);
            Document document = envelope.getDocument();
            if (document.exists()) {
                UnizhImpl unizhImpl = new UnizhImpl(document);
                value = unizhImpl.getRedirectURI();
            }

            // no file found or it's not a redirect document type or href attribute is missing
            if (value == null) {
                return null;
            } else {
                    Publication publication = document.getPublication();
    
                    String liveContext = context + "/" + publication.getId() + "/live/";
                    int start = liveContext.length(), pos = 0;
                    String rootLevel = "";
                    while ( (pos = uri.indexOf("/", start)) >= 0 )
                    {
                            rootLevel = rootLevel + "../";
                            start = pos + 1;
                    }

                    String authLenyaContext = "/lenya/" + publication.getId() + "/authoring/";
                    String href = value;
                    if (value.startsWith(authLenyaContext)) {
                            href = rootLevel + value.substring(authLenyaContext.length());
                    }

                    Map map = new HashMap();
                    map.put("href", href);
                    return map;
            }

        } catch (Exception e) {
            throw new Exception(
                "Obtaining attribute href for redirect failed: ",
                e);
        }
    }
}
