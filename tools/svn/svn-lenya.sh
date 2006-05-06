#!/bin/sh

#  Copyright 1999-2004 The Apache Software Foundation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
                                        # Configuration variables
#
# LENYA_HOME
#   The root of the Lenya distribution
#
# LENYA_WEBAPP_HOME
#   The root of the Lenya web application
#
# LENYA_LIB
#   Folder containing all the library files needed by the Lenya CLI
#
# JAVA_HOME
#   Home of Java installation.
#
# JAVA_OPTIONS
#   Extra options to pass to the JVM
#
# JAVA_DEBUG_ARGS
#   The command line arguments for the internal JVM debugger
#
# JAVA_PROFILE_ARGS
#   The command line arguments for the internal JVM profiler
                                                                                                                     
# ----- Verify and Set Required Environment Variables -------------------------
                                                                                                                                                             
if [ "$TERM" = "cygwin" ] ; then
  S=';'
else
  S=':'
fi

# ----- Check JAVA_HOME
JAVA_HOME="$JAVA_HOME"
if [ "$JAVA_HOME" = "" ];then
  echo "ERROR: No JAVA_HOME set yet!"
  echo "       Have you installed JDK 1.4.2 or higher?"
  echo ""
  echo "NOTE:  Apache Lenya does not work properly with JDK 1.5!"
  exit 1
fi

if [ "$JAVA_OPTIONS" = "" ] ; then
  JAVA_OPTIONS='-Xms32M -Xmx512M'
fi

if [ "$LENYA_HOME" = "" ] ; then
  echo "LENYA_HOME is not set. Please define LENYA_HOME."
  exit 1
fi
    
if [ "$LENYA_WEBAPP_HOME" = "" ] ; then
  STANDALONE_WEBAPP=../webapp
  if [ -d $STANDALONE_WEBAPP ] ; then
    # for standalone-webapp setup
    LENYA_WEBAPP_HOME=$STANDALONE_WEBAPP
  else
    # when in the build environment
    LENYA_WEBAPP_HOME="$LENYA_HOME/build/lenya/webapp"
  fi
fi

echo "$0: using $LENYA_WEBAPP_HOME as the webapp directory"
echo ""
echo "Make sure you did a build (ant) before! "
echo ""

if [ "$LENYA_LIB" = "" ] ; then
  LENYA_LIB="$LENYA_WEBAPP_HOME/WEB-INF/lib"
fi

ENDORSED_LIBS="$LENYA_LIB/endorsed"
ENDORSED="-Djava.endorsed.dirs=$ENDORSED_LIBS"

SCRIPT_ROOT=`dirname $0`
SCRIPT_ROOT=`cd "$SCRIPT_ROOT" ; pwd`

JAVASVN_LIBS=$SCRIPT_ROOT/lib
                                                                                        
# ----- Ignore system CLASSPATH variable
OLD_CLASSPATH="$CLASSPATH"
unset CLASSPATH
CLASSPATH=$SCRIPT_ROOT/build/classes
CLASSPATH=$CLASSPATH${S}$LENYA_LIB${S}$ENDORSED_LIBS${S}$JAVASVN_LIBS
export CLASSPATH
echo "DEBUG: $CLASSPATH"
LOADER=Loader
LOADER_LIB="${LENYA_HOME}/tools/loader"

CLI=-Dloader.main.class=org.apache.lenya.svn.LenyaSvnClient
CLI_LIBRARIES="-Dloader.jar.repositories=$CLASSPATH"

DEFAULT_UI_TYPE=cmd
#UI_TYPE=$1
#if [ "$UI_TYPE" = "" ];then
  UI_TYPE=$DEFAULT_UI_TYPE
#fi
#echo "DEBUG: $UI_TYPE"


PWD=`pwd`
if [ "$UI_TYPE" = "cmd" ];then
 echo "DEBUG: CLI and pwd $PWD"
 #ant
 java -cp $LOADER_LIB $ENDORSED $CLI_LIBRARIES $CLI $LOADER "$@"
else
  echo "ERROR: No such User Interface: $UI_TYPE"
  exit 1
fi
ERR=$?

echo ""
#echo "NOTE: Nothing yet"

# ----- Restore CLASSPATH
CLASSPATH="$OLD_CLASSPATH"
export CLASSPATH
unset OLD_CLASSPATH

# Build status return
# Usage: e.g. bash: ./build.sh; if [ $? -ne 0 ]; then echo "Build FAILED"; fi
exit $ERR
