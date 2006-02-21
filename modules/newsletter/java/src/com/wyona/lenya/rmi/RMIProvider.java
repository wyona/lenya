/**
 * 
 */
package com.wyona.lenya.rmi;

import org.apache.avalon.framework.component.Component;

/**
 * Component that provides acces to remote objects, it handles exception
 * logging and wraps the thrown exceptions into an RMIException with a
 * meaningfull message that can be presented to the user.
 * 
 * @author Gregor Imboden
 */
public interface RMIProvider extends Component {

    /**
     * Avalon Role
     */
    String ROLE = RMIProvider.class.getName();
        
    /**
     * Return an object from an rmiregistry, Exceptions will
     * be wrapped into an RMIException with a user presentable
     * message.
     * @param name the object name
     * @return the remote object
     * @throws RMIException
     */
    Object getRMIObject(String name) throws RMIException;
        
    /**
     * Check wether a object with that name exists
     * @param name the object name
     * @return true if an object by that name exists otherwise false
     */
    boolean containsObject(String name);
    
}
