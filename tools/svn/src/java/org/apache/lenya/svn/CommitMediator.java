package org.apache.lenya.svn;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import org.tmatesoft.svn.core.SVNException;
import org.tmatesoft.svn.core.io.ISVNWorkspaceMediator;

public class CommitMediator implements ISVNWorkspaceMediator {

    private Map myTmpStorages = new HashMap();
    /*
     * This may be implemented to get properties from 
     * '.svn/wcprops'
     */
    public String getWorkspaceProperty(String path, String name)
            throws SVNException {
        return null;
    }

    /*
     * This may be implemented to set properties in 
     * '.svn/wcprops'
     */
    public void setWorkspaceProperty(String path, String name, String value)
            throws SVNException {
    }

    /*
     * Creates a temporary file delta  storage. id  will be  
     * used as the temporary storage identifier. Returns an  
     * OutputStream to write the delta data into the temporary 
     * storage.
     */
    public OutputStream createTemporaryLocation(String path, Object id)
            throws IOException {
        ByteArrayOutputStream tempStorageOS = new ByteArrayOutputStream();
        myTmpStorages.put(id, tempStorageOS);
        return tempStorageOS;
    }

    /*
     * Returns an InputStream of the temporary file delta 
     * storage identified by id to read the delta.
     */
    public InputStream getTemporaryLocation(Object id) throws IOException {
        return new ByteArrayInputStream(
                  ((ByteArrayOutputStream)myTmpStorages.get(id)).toByteArray());
    }

    /*
     * Gets the length of the delta that was written  
     * to the temporary storage identified by id.
     */
    public long getLength(Object id) throws IOException {
        ByteArrayOutputStream 
                   tempStorageOS = (ByteArrayOutputStream)myTmpStorages.get(id);
        if (tempStorageOS != null) {
            return tempStorageOS.size();
        }
        return 0;
    }

    /*
     * Deletes the temporary file delta storage identified 
     * by id.
     */
    public void deleteTemporaryLocation(Object id) {
        myTmpStorages.remove(id);
    }
    
}
