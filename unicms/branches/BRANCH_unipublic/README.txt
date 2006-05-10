1. Clone from Unitemplate
======================

NOTE: Don't forget to set all the clone properties:
      /home/USERNAME/src/unipublic/tools/clone/clone.properties
      While an installation on tomcat:  
      - new.publication.prefix isn't needed
      - new.publication.name: unipublic
      - new.publication.source.dir: /home/USERNAME/src/unipublic/pubs/unipublic
      - destination.dir: /home/USERNAME/src/LENYA/build/webapp/lenya/lenya/pubs/unipublic
        NOTE: the destination.dir property must be set, else the build.xml will copy the files 
        of the unitemplate publication on the src of the unipublic one, which we doesn't want.
        It must be set to the build in lenya and not in tomcat because of the ecludes feature 
        while the building of the publication.
      

NOTE: After a SVN update of the original, the clone task needs to be executed 
      again to propagate changed files to the clone. Ant copies all files with
      a more recent last-modified date (or all files if overwrite="yes" is set in the
      copy task)

Like the clone tool of unicms

1) Edit

   /home/USERNAME/src/unizh/tools/clone/clone.properties
   
2) Edit local.build.properties in Lenya as necessary

   pubs.root.dirs=/home/USERNAME/src/unipublic/pubs/unipublic:/home/USERNAME/src/unipublic/pubs/unizh

3) Build Lenya

   Tomcat: ant install

4) Clone Publication

   ant -f /home/USERNAM/src/unipublic/tools/clone/build.xml

5) Rebuild Lenya

   ant (install)

   
2. Migration of content
=======================

The xlinks needs the path of the file on the system, so the content depends on the installation.
There is a script to fix the path while migrating the content to a new installation

/home/USERNAME/src/unipublic/pubs/unipublic/tools/searchandreplace/s-and-r.sh

Call:

./s-and-r.sh OLDPATH NEWPATH content