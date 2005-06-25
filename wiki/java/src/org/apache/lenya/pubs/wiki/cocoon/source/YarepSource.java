package org.apache.lenya.pubs.wiki.cocoon.source;

import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceNotFoundException;
import org.apache.excalibur.source.SourceUtil;
import org.apache.excalibur.source.SourceValidity;
import org.apache.log4j.Category;

import java.io.InputStream;
import java.io.IOException;
import java.net.MalformedURLException;

import org.wyona.yarep.core.Path;
import org.wyona.yarep.core.Repository;
import org.wyona.yarep.core.RepositoryFactory;

/**
 *
 */
public class YarepSource implements Source {

    private static Category log = Category.getInstance(YarepSource.class);

    private Path path;

    private String SCHEME = "yarep";

    /**
     *
     */
    public YarepSource(Path path) throws MalformedURLException {
        log.error("HUGO");
        this.path = path;
        if (!SourceUtil.getScheme(path.toString()).equals(SCHEME)) throw new MalformedURLException();
    }

    /**
     *
     */
    public boolean exists() {
        log.error("HUGO");
        return false;
    }

    /**
     *
     */
    public long getContentLength() {
        log.error("HUGO");
        return System.currentTimeMillis();
    }

    /**
     *
     */
    public InputStream getInputStream() throws IOException, SourceNotFoundException {
        log.error("HUGO");
        Repository repo = new RepositoryFactory().newRepository("wiki");
        return repo.getInputStream(new Path(SourceUtil.getSpecificPart(path.toString())));

        //return new java.io.FileInputStream("/home/michi/build/jakarta-tomcat-4.1.24-LE-jdk14/webapps/lenya/lenya/pubs/wiki/repository/paths/authoring/index.xml/resource-content");
    }

    /**
     *
     */
    public long getLastModified() {
        log.error("HUGO");
        return System.currentTimeMillis();
    }

    /**
     *
     */
    public String getMimeType() {
        log.error("HUGO");
        return null;
    }

    /**
     *
     */
    public String getScheme() {
        log.error("HUGO: " + SCHEME);
        return SCHEME;
    }

    /**
     *
     */
    public String getURI() {
        log.error("HUGO: " + path.toString());
        return path.toString();
    }

    /**
     *
     */
    public SourceValidity getValidity() {
        log.error("HUGO");
        return null;
    }

    /**
     *
     */
    public void refresh() {
        log.error("HUGO");
    }
}
