package org.apache.lenya.pubs.wiki.cocoon.source;

import org.apache.excalibur.source.ModifiableSource;
import org.apache.excalibur.source.SourceNotFoundException;
import org.apache.excalibur.source.SourceUtil;
import org.apache.excalibur.source.SourceValidity;
import org.apache.log4j.Category;

import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.MalformedURLException;

import org.wyona.yarep.core.Path;
import org.wyona.yarep.core.Repository;
import org.wyona.yarep.core.RepositoryFactory;

/**
 *
 */
public class YarepSource implements ModifiableSource {

    private static Category log = Category.getInstance(YarepSource.class);

    private Path path;

    private String SCHEME = "yarep";

    /**
     *
     */
    public YarepSource(Path path) throws MalformedURLException {
        this.path = path;
        if (!SourceUtil.getScheme(path.toString()).equals(SCHEME)) throw new MalformedURLException();
    }

    /**
     *
     */
    public boolean exists() {
        Repository repo = new RepositoryFactory().newRepository("wiki");
        return repo.exists(new Path(SourceUtil.getSpecificPart(path.toString())));
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
        return repo.getInputStream(new Path(SourceUtil.getSpecificPart(path.toString())));
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
        return path.toString();
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
        return repo.getOutputStream(new Path(SourceUtil.getSpecificPart(path.toString())));
    }
}
