#!/bin/bash

# Master script to delete Sun/Oracle Java installations from MacOS X
# Billy Constantine, The University of Adelaide, 2019

# There are a couple of places to find Java and Java-related files in MacOS X:
# - "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin" is the web browser
#   plugin.
# - "/Library/PreferencePanes/JavaControlPanel.prefPane" is the System
#   Preferences applet.
# - "$HOME/Library/Application Support/Oracle/Java" is some kind of installation
#   cache.
# - "/Library/Java/JavaVirtualMachines" contains all installed instances of both
#   the JDK and JRE, both Sun/Oracle and OpenJDK (and others?).
# - there may be other instances through /Library and $HOME/Library, mostly with
#   names that begin with "com.oracle.java"; one sure spot is
#   "/Library/Application Support/Oracle/Java", and it's probably worth checking
#   "/Library/Application Support/Sun/Java" too.
# - /private/var/db/receipts may also have files that begin with
#   "com.oracle.jdk" and/or "com.oracle.jre".

# So:
# - delete the plugin;
# - delete the System Preferences applet;
# - scan all non-system user accounts and delete installation caches;
# - check all installed JVMs and delete the Sun/Oracle ones.

# We'll split this into two parts:
# - we'll combine the deletions of the plugin, applet, and user caches into a
#   single step, since we're unconditionally deleting all those;
# - then we'll check each JVM and (1) leave the "openjdk" ones, (2) delete the
#   "java" ones, and (3) leave any others but flag them to the user.

echo ' '
if [ `/usr/bin/id -u` != 0 ]; then
   # Warn if run as a non-superuser
   echo WARNING
   echo WARNING: not running as superuser
   echo WARNING: system-wide Java cleanup may not be possible
   echo WARNING: try running "sudo $0" instead
   echo WARNING
   echo ' '
fi

# For debugging/review
# Uncomment the second line when ready
#RM='echo /bin/rm'
RM=/bin/rm

# Part one
echo Removing web browser plugin, System Preferences applet, and user installation caches
TO_BE_CHECKED=`/usr/bin/perl -le '@d=("/");setpwent();while(@F=getpwent()){unless(($F[7]=~m@^/(private/)?var@)||($F[8] eq "/usr/bin/false")){push(@d, "$F[7]/");}}endpwent();END{print(join(":", grep { -d } @d));}'`
SUBS="Library/Internet Plug-Ins/JavaAppletPlugin.plugin:Library/PreferencePanes/JavaControlPanel.prefPane:Library/Application Support/Sun/Java:Library/Application Support/Oracle/Java"
OIFS=${IFS}
IFS=':'
for d in ${TO_BE_CHECKED}; do
   for s in ${SUBS}; do
      f="${d}${s}"
      if [ -d "${f}" ]; then
         echo Deleting "${f}"
         echo ${RM} -rf ""${f}"" | /bin/bash -f
      fi
   done
   l="${d}Library"
   for s in `/usr/bin/find "${l}" -name 'com.oracle.java*' -exec echo -n {}: 2>/dev/null`; do
      echo Deleting "${s}"
      echo ${RM} -rf ""${s}"" | /bin/bash -f
   done
done
IFS=${OIFS}
for f in `/usr/bin/find /private/var/db/receipts -name 'com.oracle.jre*' -o -name 'com.oracle.jdk*' 2>/dev/null`; do
   echo Deleting "${f}"
   echo ${RM} -rf ""${f}"" | /bin/bash -f   
done
echo ' '

# Part two
echo Removing non-OpenJDK JVMs
for _jvm in `/usr/bin/find /Library/Java/JavaVirtualMachines -mindepth 1 -maxdepth 1 -type d`; do
   _java=${_jvm}/Contents/Home/bin/java
   if [ -f "${_java}" ]; then
      _type=`"${_java}" -version 2>&1 | /usr/bin/head -1 | /usr/bin/awk '{print $1}'`
      if [ "${_type}" == "openjdk" ]; then
         echo Leaving ${_jvm}
      elif [ "${_type}" == "java" ]; then
         echo Deleting ${_jvm}
         echo ${RM} -fr "${_jvm}" | /bin/bash -f
      else
         echo Unknown JVM designation "${_type}" for ${_jvm}, leaving
      fi
   fi
done

echo "Specifically checking JavaAppletPlugin..."
PLUGIN="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin"
if [ -d "${PLUGIN}" ]; then
    echo "Found ${PLUGIN}"
    ls -la "${PLUGIN}"
    echo "Attempting direct removal..."
    sudo rm -rf "${PLUGIN}"
    if [ -d "${PLUGIN}" ]; then
        echo "ERROR: Plugin still exists after removal attempt"
        echo "Current permissions:"
        ls -la "/Library/Internet Plug-Ins/"
    else
        echo "Plugin successfully removed"
    fi
else
    echo "Plugin not found"
fi

echo "Checking Oracle Java Support directory..."
ORACLE_JAVA="/Library/Application Support/Oracle/Java"
if [ -d "${ORACLE_JAVA}" ]; then
    echo "Found ${ORACLE_JAVA}"
    ls -la "${ORACLE_JAVA}"
    echo "Attempting direct removal..."
    sudo rm -rf "${ORACLE_JAVA}"
    if [ -d "${ORACLE_JAVA}" ]; then
        echo "ERROR: Oracle Java directory still exists after removal attempt"
        echo "Current permissions:"
        ls -la "/Library/Application Support/Oracle/"
    else
        echo "Oracle Java directory successfully removed"
    fi
else
    echo "Oracle Java directory not found"
fi