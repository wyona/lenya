/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package org.apache.lenya.cms.publication;

/**
 * <p>
 * An object of this class represents a sql configuration.
 * </p>
 * <p>
 * Configuration example:
 * </p>
 * <pre>
 * &lt;database name="idsw" server="mysql.uzh.ch" db="dbname" user="username" password="password"/&gt;
 * </pre>
 * 
 * @version $Id: SQLHelper.java
 */

import java.util.HashMap;

public class DbHelper {

	private static final String DB_SERVER = "serverName";
	private static final String DB_NAME = "dbName";
    private static final String DB_USERNAME ="userName";
    private static final String DB_PASSWORD = "password";

    private HashMap serverInfo = new HashMap();
    /**
     * Returns the requested info
     * 
     * @param Connection info which is neede (serverName, dbName, userName or password).
     * @return A string.
     */
    public String getServerInfo(String parameter) {
    	    return this.serverInfo.get(parameter).toString();
    }
    /**
     * Sets the server Name.
     * @param sring the name to set.
     */
    public void setServerName(String serverName) {
    	    this.serverInfo.put(this.DB_SERVER, serverName);
    }

    public void setDbName(String dbName) {
        this.serverInfo.put(this.DB_NAME, dbName);
    }

    public void setUserName(String userName) {
    	    this.serverInfo.put(this.DB_USERNAME, userName);
    }
    
    public void setPassword(String password) {
        this.serverInfo.put(this.DB_PASSWORD, password);
    }


}