
  WYONA TESTING FRAMEWORK
  -----------------------


***********************************************************************
* INTRODUCTION
***********************************************************************
This is a testing framework built on htmlunit (http://htmlunit.sourceforge.net/) 
for functional testing of Apache Lenya 1.4
It contains tests for the default and the blog publication, but can be 
extended for custom publications.


***********************************************************************
* PREREQUISITES
***********************************************************************
1) Install Ant
2) IMPORTANT: Copy lib/junit-*.jar into the lib dir of Ant (e.g. /usr/local/apache-ant-1.6.5/lib/junit-3.8.1.jar)
3) Install and build Apache Lenya and start the servlet container.



***********************************************************************
* CONFIGURATION 
***********************************************************************

The build.properties file defines which testsuite will be run and which 
configuration file will be used. To test the default publication, you 
don't have to edit that file.

If your Lenya is not running under http://localhost:8888/ you have to 
edit the default-properties.xml and specify the url/port.



***********************************************************************
* INSTALL/BUILD/RUN 
***********************************************************************

You can install/use the testing framework either with Eclipse or with 
the command line (Ant):


1. Command Line
---------------
Build and run the tests by simply typing "ant build".
Make sure that the junit.jar is installed in your Ant lib/ directory

(Configuration will be taken from build.properties, xyz-config.xml, and 
xyz-properties.xml)

To test the blog publication, use
ant -Dbuild.properties.file=blog.build.properties

to test the default publication for lenya 1.4 just type
ant

to test the default publication for lenya 1.2 just type
ant -Dbuild.properties.file=default12.build.properties

resp.

ant htmlunit


2. Eclipse
----------
1) Import this project in Eclipse (menu file > import > existing project
   into Eclipse).
2) Run the test classes (e.g. DefaultPubSuite) as JUnit tests

Note that unless you specify the property -Dhtmlunit.config.file,
the default config file will be used.



***********************************************************************
* HOW TO ADD MY OWN TESTCASE
***********************************************************************

1) Create a java class which extends LenyaTestCase in the appropriate 
   directory/package
2) Write a cool test
   If your test uses strings to verify e.g. a page title, put this 
   string into the properties.xml file of the publication. You can
   then access it from the code with config.getString(...)
3) Add the new testcase to a testsuite. If you created the testcase
   in an existing package, there should already be a testsuite there.
   Otherwise create a new testsuite and add your test. It's good 
   practice to have a hierarchical set of testsuites, i.e. one for each 
   package.
4) Run the testsuite of the publication



***********************************************************************
* HOW TO TEST MY OWN PUBLICATION
***********************************************************************

1) Create the properties.xml file (name it whatever you want)
   The easiest way to do this is to copy an existing properties file
   and change it.
   
2) Create a config.xml file (name it whatever you want)
   This file should contain a reference to the properties file you 
   created in step 1.
   It is possible to have more than one properties file listed in 
   the config file. This can be used to add/override properties of
   a default properties file.
   
3) Create a testsuite and some tests
   (see also previous section "How to add my own testcase")
   Note that you can add tests to your suite which are made for a 
   different publication (e.g. the default publication)
   This is useful for testing things which are equal in the other
   publication. Be aware that if you add a test from a "foreign" 
   publication, it will use the properties as defined in step 2.
   
4) Create a mypub.build.properties file
   This file contains the full name of your testsuite and the name
   of your config file (from step 2).
   
5) Run your testsuite by typing 
   ant -Dbuild.properties.file=mypub.build.properties
   
