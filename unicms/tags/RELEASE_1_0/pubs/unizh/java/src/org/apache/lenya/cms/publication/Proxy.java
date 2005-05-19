/*
 * Created on Jun 16, 2004
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.apache.lenya.cms.publication;

/**
 * An object of this class represents a proxy configuration.
 */
public class Proxy {

    private String url;
    private boolean isSSL;

    /**
     * Returns the absolute URL of a particular version.
     * 
     * @param version The version.
     * @return A string.
     */
    public String getURL(Version version) {
        return getUrl() + version.getDocument().getDocumentURL();
    }

    /**
     * @return Returns the url.
     */
    public String getUrl() {
        return this.url;
    }

    /**
     * @param url The url to set.
     */
    public void setUrl(String url) {
        this.url = url;
    }

    /*
     * (non-Javadoc)
     * 
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return "Proxy URL=[" + getUrl() + "]";
    }
}