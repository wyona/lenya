<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:test="http://apache.org/lenya/test/1.0" exclude-result-prefixes="test #default">
    <xsl:template match="/">
    <xsl:comment>
    Generated build file to run all tests. Targets are generated automatically.
    Targets:
    
    - projectname (all tests from a project)
    - projectname:testname (one test from a project)
    - run (all tests from all projects)
    - clean (deletes created files/folders)      
    </xsl:comment>
      
    <project name="testing" default="run" basedir=".">
      <!-- Sets classpath defined in tests.xml -->
      <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
        <path id="cp-{../@name}">
          <xsl:apply-templates select="document(concat(.,
            '/tests.xml'))/test:tests/test:classpath/*" mode="removeNamespaces"/>
        </path>
      </xsl:for-each>
      
      <target name="setup">
        <!-- Build dir for external sources -->
        <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
          <xsl:variable name="path" select="."/>
          <mkdir dir="{$path}/build"/>
        </xsl:for-each>
      </target>

      <!-- Compiles all projects -->      
      <target name="compile" description="compiles all projects">
        <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
          <xsl:variable name="path" select="."/>
          <xsl:variable name="projectname" select="../@name"/>
        <xsl:for-each select="document(concat(., '/tests.xml'))/test:tests/test:testsrc">
          <javac srcdir="{current()}" destdir="build/{$projectname}" debug="on">
            <!-- include classpath with a reference to project specified classpath (tests.xml) -->
            <classpath refid="cp-{$projectname}"/>
          </javac>
        </xsl:for-each>
        <javac srcdir="{$path}" destdir="{$path}/build" debug="on" source="1.4">
          <classpath refid="cp-{$projectname}"/>
        </javac>
        </xsl:for-each>
      </target>
      
      <xsl:comment>Target will run the tests for all projects, this is default target</xsl:comment>
      <target name="run" depends="setup,compile" description="will run all tests from all projects">
        <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
          <xsl:variable name="path" select="."/>
          <xsl:variable name="projectname" select="../@name"/>
          <echo message="Selected tests for: {$projectname} running..."/>
          <xsl:variable name="location">
            <xsl:value-of select="document(concat(., '/tests.xml'))/test:tests/test:test/@location"
            />
          </xsl:variable>
          <!-- Dont halt on failure, else a exception could thrown - not needed for the GUI -->
          <junit printsummary="yes" showoutput="true" haltonerror="off" haltonfailure="off"
            fork="true">
            <xsl:apply-templates select="document(concat(.,
              '/tests.xml'))/test:tests/test:junit-args/*" mode="removeNamespaces"/>
            <formatter type="plain" usefile="false"/>
            <formatter type="xml"/>
            <classpath refid="cp-{$projectname}"/>
            <xsl:for-each select="document(concat(., '/tests.xml'))/test:tests/test:test/@file">
              <xsl:variable name="classname">
                <xsl:value-of select="current()"/>
              </xsl:variable>
              <test name="{$classname}" todir="junit"/>
            </xsl:for-each>
          </junit>
          <echo message="Done!"/>
          <echo message=""/>
        </xsl:for-each>
      </target>
      
      <!-- not used at this moment     
      <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
        <xsl:variable name="path" select="."/>
        <xsl:variable name="projectname" select="../@name"/>
        <xsl:for-each select="document(concat(., '/tests.xml'))/test:tests/test:group/@name">
          <xsl:variable name="groupname">
            <xsl:value-of select="current()"/>
          </xsl:variable>
          <xsl:comment>Targets to run tests by group!</xsl:comment>
          <target name="{$groupname}" depends="compile">
            <xsl:for-each select="document(concat($path,'/tests.xml'))/test:tests/test:group/test:test/@file">
              <xsl:variable name="classname">
                <xsl:value-of select="substring-before(current(),'.java')"/>
              </xsl:variable>
              <java classname="{$classname}">
                <classpath>
                  <pathelement path="{$path}/build"/>
                </classpath>
              </java>
            </xsl:for-each>
          </target>
        </xsl:for-each>
      </xsl:for-each>
      -->
      
      <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
        <xsl:variable name="path" select="."/>
        <xsl:variable name="projectname" select="../@name"/>
        <xsl:comment>Target to run all tests by a project</xsl:comment>
        <target name="{$projectname}" depends="setup,compile" description="Runs all Tests of {$projectname}">
          <junit printsummary="yes" showoutput="true" haltonerror="off" haltonfailure="off"
            fork="true">
            <xsl:apply-templates select="document(concat(.,
              '/tests.xml'))/test:tests/test:junit-args/*" mode="removeNamespaces"/>
            <!-- disabling the plaintext formatter, but use the xml formatter -->
            <formatter type="plain" usefile="false"/>
            <formatter type="xml"/>
            <classpath refid="cp-{$projectname}"/>
            <xsl:for-each select="document(concat(., '/tests.xml'))/test:tests/test:test/@file">
              <xsl:variable name="classname">
                <xsl:value-of select="current()"/>
              </xsl:variable>
              <test name="{$classname}" todir="junit"/>
            </xsl:for-each>
          </junit>
        </target>
      </xsl:for-each>
      
      <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
        <xsl:variable name="path" select="."/>
        <xsl:variable name="projectname" select="../@name"/>
        <xsl:for-each select="document(concat(., '/tests.xml'))/test:tests/test:test/@file">
          <xsl:variable name="classname" select="current()"/>
          <xsl:variable name="classname_short">
            <!-- strip package name -->
            <xsl:call-template name="substring-after-last">
              <xsl:with-param name="input" select="current()"/>
              <xsl:with-param name="substr" select="'.'"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:comment>Targets to run just one test by name!</xsl:comment>
          <target name="{$projectname}:{$classname_short}" depends="setup,compile" description="Runs just {$classname_short}">
            <junit printsummary="yes" showoutput="true" haltonerror="off" haltonfailure="off"
              fork="true">
              <xsl:apply-templates select="../../test:junit-args/*" mode="removeNamespaces"/>
              <formatter type="plain" usefile="false"/>
              <formatter type="xml"/>
              <classpath refid="cp-{$projectname}"/>
              <test name="{$classname}" todir="junit"/>
            </junit>
          </target>
        </xsl:for-each>
      </xsl:for-each>
      
      <target name="clean" description="This will delete all created build folders">
        <xsl:comment>Deleting all created build dirs</xsl:comment>
        <xsl:for-each select="document('../projects.xml')/test:projects/test:project/test:path">
          <xsl:variable name="path" select="."/>
          <delete dir="{$path}/build"/>
        </xsl:for-each>
      </target>
      
    </project>
    
  </xsl:template>
  <!-- Template to remove namespaces on elements, we source different external xml's and dont wont
  wront namespaces in the generated build file --> 
  <xsl:template match="*" mode="removeNamespaces">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="node()" mode="removeNamespaces"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="text() | comment()" mode="removeNamespaces">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- Template to get Javaclass Name out of a full package path -->
  <xsl:template name="substring-after-last">
    <xsl:param name="input"/>
    <xsl:param name="substr"/>
    <xsl:variable name="temp" select="string(substring-after($input, $substr))"/>
    <xsl:choose>
      <xsl:when test="$substr and contains($temp, $substr)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="input" select="string($temp)"/>
          <xsl:with-param name="substr" select="string($substr)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="string($temp)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
