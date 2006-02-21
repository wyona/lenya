package com.wyona.lenya.rmi;

/**
 * This exception is used a wapper around various RMI related exceptions
 * 
 * @author Gregor Imboden
 */
public class RMIException extends Exception {

    public RMIException() {
        super();
    }

    /**
     * Create an RMIException
     * 
     * @param message The message
     */
    public RMIException(String message) {
        super(message);
    }
    
    /**
     * Create an RMIException
     * 
     * @param message The message
     * @param cause The cause
     */
    public RMIException(String message, Throwable cause) {
        super(message, cause);
    }    
    
    /**
     * Create an RMIException
     * 
     * @param cause The cause
     */
    public RMIException(Throwable cause) {
        super(cause);
    }
    
}
