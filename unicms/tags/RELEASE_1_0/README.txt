Cloning Publication
===================

NOTE: After a CVS update of the original, the clone task needs to be executed 
      again to propagate changed files to the clone. Ant copies all files with
      a more recent last-modified date (or all files if overwrite="yes" is set in the
      copy task)

1) Edit

   /home/USERNAME/src/unizh/tools/clone/clone.properties
   
   by making a copy of clone.properties.sample and editing the following values:
   
   new.publication.prefix
   new.publication.name
   new.publication.source.dir
   destination.dir

2) Edit local.build.properties in Lenya as necessary

   pubs.root.dirs=/home/USERNAME/src/unizh/pubs:/home/USERNAME/src/lenya-pubs/physics

3) Build Lenya

   Jetty:  ant
   Tomcat: ant install

4) Clone Publication

   ant -f /home/USERNAM/src/unizh/tools/clone/build.xml

5) Rebuild Lenya

   ant (install)
