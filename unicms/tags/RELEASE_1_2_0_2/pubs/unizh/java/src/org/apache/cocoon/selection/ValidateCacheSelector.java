/*
 * Copyright 1999-2004 The Apache Software Foundation.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.cocoon.selection;

import java.util.Map;
import java.util.Date;
import java.text.DateFormat;

import org.apache.avalon.framework.activity.Disposable;
import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.Serviceable;
import org.apache.avalon.framework.thread.ThreadSafe;

import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;

import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceNotFoundException;
import org.apache.excalibur.source.SourceResolver;

/**
 * This class enhances the org.apache.cocoon.selection.ResourceExistsSelector
 * 
 * It additionally checks the difference between the lastModified date and the 
 * actual date. The selector should return true only if the resource exists and 
 * the cache entry is not older than a defined value.
 * 
 * <p><b>configuration</b></p>
 * <code>cache-expires</code> the expires value in s. Default is 1800s
 *
 * @author <a href="mailto:jann@apache.org">Jann Forrer</a>
 */
public class ValidateCacheSelector extends AbstractLogEnabled
                                    implements ThreadSafe, Serviceable, Disposable, Selector, Configurable {

    private ServiceManager manager;
    private SourceResolver resolver;
    protected String defaultName;
    protected long defaultValue;
    
    public void configure(Configuration config) throws ConfigurationException {
        this.defaultName = config.getChild("cache-expires").getValue("1800");
        this.defaultValue = Long.parseLong(defaultName);
    }
    
    public void service(ServiceManager manager) throws ServiceException {
        this.manager = manager;
        this.resolver = (SourceResolver)manager.lookup(SourceResolver.ROLE);
    }

    public void dispose() {
        this.manager.release(this.resolver);
        this.resolver = null;
        this.manager = null;
    }
    
    public boolean select(String expression, Map objectModel, Parameters parameters) {
        String resourceURI = parameters.getParameter("prefix", "") + expression;
        Source source = null;
        try {
            source = resolver.resolveURI(resourceURI);
            if (isCacheExpired(source)) return false;
            return source.exists();
        } catch (SourceNotFoundException e) {
            return false;
        } catch (Exception e) {
            getLogger().warn("Exception resolving resource " + resourceURI, e);
            return false;
        } finally {
            if (source != null) {
                resolver.release(source);
            }
        }
    }
    
    protected boolean isCacheExpired (Source source) {
        boolean isexpired = false;
        
        long now = new Date().getTime();
        long lastModified = source.getLastModified();
        double difference = now - lastModified;
        long seconds = Math.round(difference/1000);
        
        if (seconds > this.defaultValue) isexpired = true;
        return isexpired;
    }
}
