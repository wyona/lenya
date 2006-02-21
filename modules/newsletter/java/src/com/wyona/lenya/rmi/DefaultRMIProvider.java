/**
 * 
 */
package com.wyona.lenya.rmi;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.util.HashMap;

import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.logger.AbstractLogEnabled;

/**
 * Default RMIProvider implementation
 * 
 * @author Gregor Imboden
 */
public class DefaultRMIProvider extends AbstractLogEnabled implements RMIProvider, Configurable {
    
    /** Containts the url to object name mappings */ 
    private HashMap urlName;
    
    private final static String OBJECT_ELEMENT_NAME = "object";
    private final static String URL_ATTRIBUTE_NAME = "url";
    private final static String NAME_ATTRIBUTE_NAME = "name";    
    
    /* (non-Javadoc)
     * @see com.wyona.lenya.rmi.RMIProvider#getRMIObject(java.lang.String)
     */
    public Object getRMIObject(String name) throws RMIException {
        if (!containsObject(name)) {
            throw new RMIException("Requested object not configured, check the RMI configuration: " + name);
        } else {
            String rmiUrl = (String) this.urlName.get(name);
            Object remoteObject = null;
            try {
                remoteObject = Naming.lookup(rmiUrl);
            } catch (RemoteException e) {
                String msg = "Connection to the RMIregistry failed, check the connection: " + rmiUrl;
                getLogger().error(msg, e);
                throw new RMIException(msg, e);
            } catch (MalformedURLException e) {
                String msg = "Mallormed RMI url: " + rmiUrl;
                getLogger().error(msg, e);
                throw new RMIException(msg, e);
            } catch (NotBoundException e) {
                String msg = "Requested object not bound, check your RMI configuration: " + rmiUrl;
                getLogger().error(msg, e);
                throw new RMIException(msg, e);
            }
            return remoteObject;
        }        
    }

    /* (non-Javadoc)
     * @see com.wyona.lenya.rmi.RMIProvider#containsObject(java.lang.String)
     */
    public boolean containsObject(String name) {
        return this.urlName.containsKey(name);
    }

    /* (non-Javadoc)
     * @see org.apache.avalon.framework.configuration.Configurable#configure(org.apache.avalon.framework.configuration.Configuration)
     */
    public void configure(Configuration config) throws ConfigurationException {
        this.urlName = new HashMap();
        Configuration[] configurations = config.getChildren(OBJECT_ELEMENT_NAME);
        for (int i=0; i<configurations.length; i++) {
            String url = configurations[i].getAttribute(URL_ATTRIBUTE_NAME);
            String name = configurations[i].getAttribute(NAME_ATTRIBUTE_NAME);            
            if (name == null) {
                throw new ConfigurationException("The object does not have a name");
            }
            if (isValidRMIUrl(url)) {
                this.urlName.put(name, url);
                getLogger().debug("added RMI object: " + name + " - " + url);
            } else {            
                throw new ConfigurationException("The RMI url is not valid: " + url);
            }            
        }        
    }
    
    /**
     * Check if url is a valid RMI Url ex: //somehost:port/someobject
     * @param url the url candidate
     * @return true if the url is valid otherwise false
     */
    public boolean isValidRMIUrl(String url) {
        return url.matches("^//[\\d\\w]+([:][\\d]{1,5})([/][\\d\\w]+)*");
    }

}
