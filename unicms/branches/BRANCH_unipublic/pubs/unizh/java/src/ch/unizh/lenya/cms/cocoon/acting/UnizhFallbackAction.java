/*
$Id: UnizhFallbackAction.java,v 1.4 2003/12/19 17:27:36 jann Exp $
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

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.DefaultConfigurationBuilder;
import org.apache.avalon.framework.configuration.ConfigurationException;

import org.apache.cocoon.acting.AbstractConfigurableAction;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.SourceResolver;

import org.apache.excalibur.source.Source;

import org.apache.lenya.cms.publication.PageEnvelope;
import org.apache.lenya.cms.publication.PageEnvelopeFactory;
import org.apache.lenya.cms.publication.Publication;

import java.io.File;

import java.util.Collections;
import java.util.Map;

/**
 * This action handles  the fallback between a so called root publication
 * and the actual publication. If a resource is not found within the actual 
 * publication it is searched in the root publication.
 * 
 * There is also a parameter needed saying where the file is located in the root Publication
 * <map:parameter name="rootpath" value="resources/images/{2}.gif"/>
 * 
 * @author <a href="mailto:jann.forrer@id.unizh.ch">Jann Forrer</a>
 */
public class UnizhFallbackAction extends AbstractConfigurableAction {

    public static final String CONFIGURATION_FILE =
        "config/unizh/unizh.xconf".replace('/', File.separatorChar);

    public static final String ROOT_ID = "root-publication";
    public static final String PARAMETER_ROOTPATH = "rootpath";
    public static final String PARAMETER_EXISTING_PATH = "existing-path";

    /**
     * @see org.apache.avalon.framework.configuration.Configurable#configure(org.apache.avalon.framework.configuration.Configuration)
     */
    public void configure(Configuration conf) throws ConfigurationException {
        super.configure(conf);
    }

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

        String urlString = source;
        String rootPublicationPath = parameters.getParameter(PARAMETER_ROOTPATH, source);
        String existingPath = "";

        PageEnvelope envelope = PageEnvelopeFactory.getInstance().getPageEnvelope(objectModel);
        Publication publication = envelope.getPublication();

        File configurationFile = new File(publication.getDirectory(), CONFIGURATION_FILE);

        DefaultConfigurationBuilder builder = new DefaultConfigurationBuilder();
        Configuration config = builder.buildFromFile(configurationFile);
        String rootId = config.getChild(ROOT_ID).getValue();

        Source src = null;
        try {
            src = resolver.resolveURI(urlString);

            if (src.exists() || (rootId == null)) {
                getLogger().info(".act(): File exists: " + existingPath);

                existingPath = urlString;
            } else {
                existingPath = "../" + rootId + "/" + rootPublicationPath;
                getLogger().error(".act(): File " + existingPath + "\" does not exist");
            }
        } finally {
            if (src != null) {
                resolver.release(src);
            }
        }

        Map map = Collections.singletonMap(PARAMETER_EXISTING_PATH, existingPath);
        return map;
    }

}
