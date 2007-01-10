#------
#
#    22.11.2006(trd): script for clearing dummy namespace when installing the xsl files of the uzh publication
#
#------

How to install the specific templating for the uzh publication:

1) clone the uzh publication INTO /path/to/lenya-src/build/lenya/webapp/lenya/pubs
   (this is where your uzh templates will be installed)

(in the current directory)

2) ant install
3) make sure that you have execute permission on "clear-dummy-ns.sh"
4) ant clearns
5) install lenya (including unicms)
