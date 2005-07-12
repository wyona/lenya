package org.apache.lenya.pubs.wiki.cocoon.source;

import org.apache.excalibur.source.ModifiableSource;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceNotFoundException;
import org.apache.excalibur.source.SourceUtil;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.TraversableSource;
import org.apache.log4j.Category;

import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.util.Collection;

import org.wyona.yarep.core.Path;
import org.wyona.yarep.core.Repository;
import org.wyona.yarep.core.RepositoryFactory;

/**
 *
 */
public class YarepSource implements ModifiableSource, TraversableSource {

    private static Category log = Category.getInstance(YarepSource.class);

    private Path path;

    private String SCHEME = "yarep";

    /**
     *
     */
    public YarepSource(String src) throws MalformedURLException {
        if (!SourceUtil.getScheme(src.toString()).equals(SCHEME)) throw new MalformedURLException();
        this.path = new Path(SourceUtil.getSpecificPart(src.toString()));
    }

    /**
     *
     */
    public boolean exists() {
        Repository repo = new RepositoryFactory().newRepository("wiki");
        return repo.exists(path);
    }

    /**
     *
     */
    public long getContentLength() {
        log.warn("Not implemented yet!");
        return System.currentTimeMillis();
    }

    /**
     *
     */
    public InputStream getInputStream() throws IOException, SourceNotFoundException {
        Repository repo = new RepositoryFactory().newRepository("wiki");
        return repo.getInputStream(path);
    }

    /**
     *
     */
    public long getLastModified() {
        log.warn("Not implemented yet!");
        return System.currentTimeMillis();
    }

    /**
     *
     */
    public String getMimeType() {
        log.warn("Not implemented yet!");
        return null;
    }

    /**
     *
     */
    public String getScheme() {
        return SCHEME;
    }

    /**
     *
     */
    public String getURI() {
        log.warn("Not really implemented yet! Path: " + path);
        return "file:" + path.toString();
    }

    /**
     *
     */
    public SourceValidity getValidity() {
        log.warn("Not implemented yet!");
        return null;
    }

    /**
     *
     */
    public void refresh() {
        log.warn("Not implemented yet!");
    }

    /**
     *
     */
    public boolean canCancel(OutputStream out) {
        log.warn("Not implemented yet!");
        return false;
    }

    /**
     *
     */
    public void cancel(OutputStream out) {
        log.warn("Not implemented yet!");
    }

    /**
     *
     */
    public void delete() {
        log.warn("Not implemented yet!");
    }

    /**
     *
     */
    public OutputStream getOutputStream() throws IOException {
        Repository repo = new RepositoryFactory().newRepository("wiki");
        return repo.getOutputStream(path);
    }

    /**
     *
     */
    public Source getParent() {
        log.warn("Not implemented yet!");
        return null;
    }

    /**
     *
     */
    public String getName() {
        log.warn("Not implemented yet!");
        return null;
    }

    /**
     *
     */
    public Source getChild(String name) {
        log.warn("Not implemented yet!");
        return null;
    }

    /**
     *
     */
    public Collection getChildren() {
        log.warn("Not implemented yet!");
        return null;
    }

    /**
     *
     */
    public boolean isCollection() {
        log.warn("Not implemented yet!");
        return false;
    }
}
