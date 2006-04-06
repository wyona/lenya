Module to integrate TinyMCE editor for Lenya 1.4

Work in progress. You are welcome to contribute.

Install:
- copy this module to src/modules
- download tinymce from http://tinymce.moxiecode.com/ and 
  copy the content of the dir jscript inside of this module 
  ressources/javascript (this should look like this:
  modules/tinymce/resources/javascript/tiny_mce/... )
- to add the menu entry, in yourpub/config/publication.xconf
  add  <module name="tinymce"/> under <module name="xhtml"/>