DATABASE EXAMPLE PUBLICATION
----------------------------
This is an exmample pbulication in order to demonstrate 
a possible solution to access database content from a CMS 
page. 

Procedure to make it work
------------------------

1.) You need to patch the lenya core using the following two
    patch-files: 
    - Publication.patch 
    - AbstractPublication.patch


2.) Define the input module in cocoon.xconf 
    <component-instance name="dbconinfo" logger="sitemap.modules.input.dbconinfo" 
                        class="org.apache.lenya.cms.cocoon.components.modules.input.SqlModule"/>

3.) You need a connector jar-file for the database you use, put it in the WEB-INF/lib direcotry of 
    your servlet engine and define it in the cocoon.xconf file:

    for mysql:
       <jdbc name="mysqlPool">
         <pool-controller min="5" max="10"/>
         <auto-commit>true</auto-commit>
         <driver>com.mysql.jdbc.Driver</driver>
       </jdbc>

     or for oracle
       <jdbc> 
         <jdbc name="oraclePool">
         <pool-controller min="5" max="10"/>
         <auto-commit>true</auto-commit>
         <driver>oracle.jdbc.driver.OracleDriver</driver>
       </jdbc>
 

