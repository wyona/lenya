package org.apache.lenya.svn;

public class StatusBean {
    private String status;

    private String path;

    private long workingRevision;

    private long lastChangedRevision;

    /**
     * @return Returns the lastChangedRevision.
     */
    public long getLastChangedRevision() {
        return lastChangedRevision;
    }

    /**
     * @param lastChangedRevision
     *            The lastChangedRevision to set.
     */
    public void setLastChangedRevision(long lastChangedRevision) {
        this.lastChangedRevision = lastChangedRevision;
    }

    /**
     * @return Returns the workingRevision.
     */
    public long getWorkingRevision() {
        return workingRevision;
    }

    /**
     * @param workingRevision
     *            The workingRevision to set.
     */
    public void setWorkingRevision(long workingRevision) {
        this.workingRevision = workingRevision;
    }

    /**
     * @return Returns the path.
     */
    public String getPath() {
        return path;
    }

    /**
     * @param path
     *            The path to set.
     */
    public void setPath(String path) {
        this.path = path;
    }

    /**
     * @return Returns the status.
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status
     *            The status to set.
     */
    public void setStatus(String status) {
        this.status = status;
    }
}
