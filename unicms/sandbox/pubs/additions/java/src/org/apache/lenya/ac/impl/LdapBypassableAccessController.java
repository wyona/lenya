/*
 * Copyright  1999-2004 The Apache Software Foundation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
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

/* $Id: LdapBypassableAccessController.java 11879 2006-03-22 14:20:05Z jann $  */

package org.apache.lenya.ac.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.io.File;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.Session;
import org.apache.cocoon.sitemap.PatternException;
import org.apache.lenya.ac.AccessControlException;
import org.apache.regexp.RE;
import org.apache.regexp.RECompiler;
import org.apache.regexp.REProgram;
import org.apache.regexp.RESyntaxException;

import org.apache.lenya.ac.Authorizer;
import org.apache.lenya.ac.impl.LdapACHelper;

import org.apache.lenya.cms.publication.Publication;
import org.apache.lenya.cms.publication.PublicationFactory;
import org.apache.lenya.cms.publication.Document;
import org.apache.lenya.cms.publication.DocumentBuildException;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceResolver;
import org.apache.excalibur.source.SourceUtil;

/**
 * AccessController that can be bypassed for certain URL patterns.
 */
public class LdapBypassableAccessController extends DefaultAccessController {

    /**
     * Ctor.
     */
    public LdapBypassableAccessController() {
    }

    private List publicMatchers = new ArrayList();

    private String LDAP_USER = "LdapUser";

    private String LDAP_GROUP = "allldap";
    private String KOORD_GROUP = "koord";
    private String WWWK_GROUP = "wwwkoord";
    private String NETZ_KOORD = "netzkoord";

    protected static final String SUBTREE_FILENAME = "subtree-policy.acml";

    /**
     * @see org.apache.avalon.framework.configuration.Configurable#configure(org.apache.avalon.framework.configuration.Configuration)
     */
    public void configure(Configuration conf) throws ConfigurationException {
        super.configure(conf);

        getLogger().debug("Configuring bypass patterns");

        Configuration[] publics = conf.getChildren("public");

        for (int i = 0; i < publics.length; i++) {
            String publicHref = publics[i].getValue(null);

            try {
                publicMatchers.add(preparePattern(publicHref));
            } catch (PatternException pe) {
                throw new ConfigurationException(
                        "invalid pattern for public hrefs", pe);
            }

            if (getLogger().isDebugEnabled()) {
                getLogger().debug("CONFIGURATION: public: " + publicHref);
            }
        }

    }

    /**
     * Compile the pattern in a <code>org.apache.regexp.REProgram</code>.
     * 
     * @param pattern
     *            The pattern to compile.
     * @return A RE program representing the pattern.
     * @throws PatternException
     *             when something went wrong.
     */
    protected REProgram preparePattern(String pattern) throws PatternException {
        if (pattern == null) {
            throw new PatternException("null passed as a pattern", null);
        }

        if (pattern.length() == 0) {
            pattern = "^$";

            if (getLogger().isWarnEnabled()) {
                getLogger()
                        .warn(
                                "The empty pattern string was rewritten to '^$'"
                                        + " to match for empty strings.  If you intended"
                                        + " to match all strings, please change your"
                                        + " pattern to '.*'");
            }
        }

        try {
            RECompiler compiler = new RECompiler();
            REProgram program = compiler.compile(pattern);

            return program;
        } catch (RESyntaxException rse) {
            getLogger().debug(
                    "Failed to compile the pattern '" + pattern + "'", rse);
            throw new PatternException(rse.getMessage(), rse);
        }
    }

    /**
     * Matches a string using a prepared pattern program.
     * 
     * @param preparedPattern
     *            The pattern program.
     * @param match
     *            The string to match.
     * @return <code>true</code> if the string matched the pattern,
     *         <code>false</code> otherwise.
     */
    protected boolean preparedMatch(REProgram preparedPattern, String match) {
        boolean result = false;

        if (match != null) {
            RE re = new RE(preparedPattern);
            result = re.match(match);
        }
        return result;
    }

    /**
     * @see org.apache.lenya.ac.AccessController#authorize(org.apache.cocoon.environment.Request)
     */
public boolean authorize(Request request)
        throws AccessControlException {
        
//        assert request != null;
        
        boolean authorized = false;
        boolean isLdapUser=false;
        
        String uri = request.getRequestURI();
        String context = request.getContextPath();
        Session session = request.getSession(false);
        if (session.getAttribute(this.LDAP_USER) == null) session.setAttribute(this.LDAP_USER, "false");
        if (session.getAttribute("DocId") == null) session.setAttribute("DocId", null);

        if (context == null) {
            context = "";
        }
        uri = uri.substring(context.length());
        
        // Check public uris from configuration above. Should only be used
        // during development
        // before the implementation of a concrete authorizer.
        int i = 0;
        while (!authorized && i < publicMatchers.size()) {
            getLogger().debug("Trying pattern: [" + publicMatchers.get(i) + "] with URL [" + uri + "]");
            if (preparedMatch((REProgram) publicMatchers.get(i), uri)) {
                if (getLogger().isDebugEnabled()) {
                    getLogger().debug("Permission granted for free: [" + uri + "]");
                }
                authorized = true;
            }
            i++;
        }
        
        if (!authorized) {
            authorized = super.authorize(request);
            if (session.getAttribute(this.LDAP_USER).equals("true")) isLdapUser = true;
            // if !authorized but there is an AllLdapGroup and the user is
            // authenticated
            // set authorize to true anyway.
            if (!authorized && isLdapUser && isInAcLdapDir(request, session)) {
               authorized=true;	
           }
        }
        return authorized;
    }
    /**
     * @see org.apache.lenya.ac.AccessController#authenticate(org.apache.cocoon.environment.Request)
     */
public boolean authenticate(Request request) throws AccessControlException {

        String PATH = "config" + File.separator + "ac" + File.separator
                + "passwd";
        boolean authenticated = false;
        
        String webappUrl = request.getRequestURI().substring(
                request.getContextPath().length());
        
        try {
            Publication pub = getPublication(webappUrl);
            Document doc = pub.getDocumentBuilder().buildDocument(pub,
                    webappUrl);
            String configPath = pub.getDirectory().getAbsolutePath()
                    + File.separator + PATH;

            Vector allGroups = getAcGroups(doc, webappUrl);
            Authorizer[] authorizers = getAuthorizers();
            int i = 0;
            int ii = 0;

            File configDir = new File(configPath);
            String userName = request.getParameter("username");

            if (hasAuthorizers() && doc.getArea().equals(Publication.LIVE_AREA)) {
                while (i < authorizers.length) {
                    if (authorizers[i] instanceof PolicyAuthorizer) {
                        
                        while (ii < allGroups.size()) {
                            if (allGroups.contains(this.LDAP_GROUP.toLowerCase())) {
                                authenticated = this.authenticateLdapUser(request,
                                        userName, configDir);
                            } if ((allGroups.contains(this.KOORD_GROUP
                                    .toLowerCase()))
                                    && (!authenticated)) {
                                if (userIsInGroup(this.KOORD_GROUP, userName,
                                        configDir)) {
                                    authenticated = this.authenticateLdapUser(
                                            request, userName, configDir);
                                }
                            } if ((allGroups.contains(this.NETZ_KOORD
                                    .toLowerCase()))
                                    && (!authenticated)) {
                                if (userIsInGroup(this.NETZ_KOORD, userName,
                                        configDir)) {
                                    authenticated = this.authenticateLdapUser(
                                            request, userName, configDir);
                                }
                            } if ((allGroups.contains(this.WWWK_GROUP
                                    .toLowerCase()))
                                    && (!authenticated)) {
                                if (userIsInGroup(this.WWWK_GROUP, userName,
                                        configDir)) {
                                    authenticated = this.authenticateLdapUser(
                                            request, userName, configDir);
                                }
                            }
                            ii++;
                        }
                        if (authenticated) {
                            Session session = request.getSession(true);
                            session.setAttribute(this.LDAP_USER, "true");
                            session.setAttribute("DocId", doc);
                            return authenticated;
                        }
                    }
                    i++;
                }
            }
        } catch (DocumentBuildException ex) {
            ex.printStackTrace();
        }
        
        authenticated = super.authenticate(request);
        return authenticated;
    }

    /**
     * Determines the publications from the url
     * 
     * @param url: The webapp url.
     * 
     */
    protected Publication getPublication(String url)
            throws AccessControlException {

        Source source = null;
        SourceResolver resolver = null;
        Publication publication;

        ServiceManager serviceManager = this.getManager();

        try {
            resolver = (SourceResolver) serviceManager
                    .lookup(SourceResolver.ROLE);
            source = resolver.resolveURI("context:///");
            File servletContext = SourceUtil.getFile(source);
            publication = PublicationFactory
                    .getPublication(url, servletContext);
        } catch (Exception e) {
            throw new AccessControlException(e);
        } finally {
            if (resolver != null) {
                if (source != null) {
                    resolver.release(source);
                }
                serviceManager.release(resolver);
            }
        }
        return publication;
    }
    
    /**
     * Read policy files and put all occurring groups into a vector
     * 
     * @param doc: The Document belonging to the request
     *        url: The respective url
     * @return A vector containing all groups found in the policy file 
     * 
     * FIXME: hack! Use the lenya API to get the groups
     */
    protected Vector getAcGroups(Document doc, String url) {

        Vector groups = new Vector();
        int ii = 0;
        
        File parent = doc.getFile().getParentFile();
        String parentPath = parent.getAbsolutePath();
        String areaPrefix = File.separator + doc.getArea();
        String documentPath = parentPath.substring(parentPath.indexOf(areaPrefix));
        
        while ((!documentPath.equalsIgnoreCase(areaPrefix)) && (ii < 10 )){
            
            File policyDir = new File(doc.getPublication().getDirectory().getAbsolutePath()
                    + File.separator + "config/ac/policies");

            File policyFile = new File(policyDir, File.separator
                    + documentPath + File.separator + SUBTREE_FILENAME);
            if (policyFile.exists()) {
                LdapACHelper ldapAcHelper = new LdapACHelper();
                groups = ldapAcHelper.getAcGroups(policyFile);
                break;
            } else {
                parent = parent.getParentFile();
                parentPath = parent.getAbsolutePath();
                documentPath = parentPath.substring(parentPath.indexOf(areaPrefix));
            }
            ii++;
        }
        
        return groups;
    }
    
    /**
     * Determines whether the user which tries to login is in the respective 
     * 
     * @param groupid: The groupid to check for a user
     *        username: The username to check for
     *        configdir: A File pointng to the AC-Directory 
     * @return boolean  
     * 
     * TODO: The relation userTOgroup is stored in a file. It is hardcoded as .htgroup i.e. very
     *       IT Service specific. Use a more generic approach....
     */  
    protected boolean userIsInGroup (String groupId, String userName, File configDir){
 
        Vector allIds = new Vector();
        if (configDir.exists()){
            String htGroupFile = configDir.getAbsolutePath() + File.separator + ".htgroup";
            LdapACHelper ldapAcHelper = new LdapACHelper();
            allIds = ldapAcHelper.getAllUserInGroup(groupId, htGroupFile);
            if (allIds.contains(userName)) return true;
        }
        return false;
    }

    /**
     * Generate a LdapUser on the fly and use super.authenticate. 
     * Note: that user does not occur in the system but only in 
     * the Ldap Server.
     * 
     * @param reuest: 
     *        username: The username to authenticate 
     *        configdir: A File pointng to the AC-Directory 
     * @return boolean  
     * 
     */  
 
    protected boolean authenticateLdapUser(Request request, String userName, File configDir) throws AccessControlException {

        boolean authenticated = false;
        
        try {
            org.apache.lenya.ac.ldap.LDAPUser ldapuser = new org.apache.lenya.ac.ldap.LDAPUser(
                    configDir, userName, "noreply@unizh.ch", userName);
            if (ldapuser.existsUser(userName)) {
                authenticated = super.authenticate(request, ldapuser);
            }

        } catch (ConfigurationException e) {
            getLogger().warn("LDAP user configuration exception: " + e);
        }
        return authenticated;
    }
    
    protected boolean isInAcLdapDir(Request request, Session session){
        
        Document doc = (Document) session.getAttribute(("DocId"));

        if (doc != null) { 
            String webappUrl = request.getRequestURI().substring(
                    request.getContextPath().length());
            String prefix = File.separator + doc.getPublication().getId() + File.separator + doc.getArea();
            String canonicalUrl = webappUrl.substring(prefix.length());
       
            if (canonicalUrl.startsWith(doc.getId())) {
                return true;
            } else {
                return false;
            }
        }
        return true;
    }
    
}
