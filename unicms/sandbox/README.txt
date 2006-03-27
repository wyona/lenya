Additions to the unizh Publication
----------------------------------

In the sandbox additons to the unizh publications

http://svn.wyona.org/repos/public/lenya/unicms/trunk

are stored due ot the following reasons: 

- The do not belong to the main repo because the are not finished yet
- They request patching the lenya-core. Necessary patches will be included in 
  this repo under /patches and will be described in this README. 


PATCHES
-------

- patches/acPatch.txt: Patching some AC classes in the lenya core. This patch is necessary 
  for the class org/apache/lenya/ac/impl/LdapBypassableAccessController.java  which is a 
  very publication specific access controller. It checks for the occurence of groups in AC Live 
  and if one of it exist it bypasses the authorisation for that page.   
