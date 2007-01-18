#------
#
#    17.01.2007 (trd): How to install the specific templating for a UZH Corporate Website publication 
#
#------


1) (in UNICMS_SRC_DIR/tools/clone/)
   clone a unitemplate INTO /path/to/lenya-src/build/lenya/webapp/lenya/pubs (name it "public", "staff", ...))

# set 'homepage=reset' to install a portal homepage (note: the "public" publication gets a specific homepage)

2) (in the current directory)
   ant install

3) (in LENYA_SRC_DIR)
   install lenya (including unicms)



#------
#
#    17.01.2007 (trd): How to install this specific templating for several UZH Corporate Website publications at once
#
#------


1) (in the current directory)
   list the publications in all-cws-pubs.txt
   ./all-cws-pubs-clone.pl
   ./all-cws-pubs-install.pl

2) (in LENYA_SRC_DIR)
   install lenya (including unicms)
