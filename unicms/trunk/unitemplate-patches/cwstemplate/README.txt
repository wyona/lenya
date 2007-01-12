#------
#
#    22.11.2006(trd): script for clearing dummy namespace when installing the xsl files of the uzh publication
#
#------

How to install the specific templating for the uzh publication:

1) (in UNICMS_SRC_DIR/tools/clone/)
   clone the uzh publication INTO /path/to/lenya-src/build/lenya/webapp/lenya/pubs
     (this is where your uzh templates will be installed)

# clone script in preparation - make sure that you have execute permission on it

2) (in the current directory)
   ant install

3) (in LENYA_SRC_DIR)
   install lenya (including unicms)
