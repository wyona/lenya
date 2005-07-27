
   R E A D M E
   ===========

   Automatic Headlines update
   --------------------------
   
   1) The html rss file is generated with the static Export task when the frontpage is published.
   2) The html file is then copied on the unizh.ch server with the replication task 
   3. The replication task is run from a cronjob.
   
   See following README of the replication:
       

   Requirements for the replication
   --------------------------------

   1) Ant 1.6.X or higher (installed on the Apache Lenya Authoring machine)

   2) Download the additonal libraries

        - ant-contrib-1.0b1.jar (http://ant-contrib.sourceforge.net/)
        - jsch-20040329.jar (http://www.jcraft.com/jsch/index.html, http://www.ibiblio.org/maven2/ant/ant-jsch/)

      and copy them to the lib dir of ant (e.g. /usr/local/apache-ant-1.6.2/lib)

   3) Create an SSH key

        ssk-keygen -t dsa (or -t rsa)

      and copy to remote server 

        scp .ssh/id_dsa.pub REMOTE_SERVER:.ssh/authorized_keys

      HOWTO for Windows: http://graphics.stanford.edu/infrastructure/net/putty.html


   Howto Replicate
   ---------------

   1) Copy build.properties to local.build.properties

   2) Set the following parameters within local.build.properties

      - pub.dir
      - local.keyfile
      - default.username
      - default.remote.dir
      - remote1.host (uncomment and set the other remote servers if necessary)

   3) Replicate the content by running ant -f build.xml

