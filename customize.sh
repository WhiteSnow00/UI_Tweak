#!/sbin/sh

# Config Vars
# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

# Info Print
SCRIPT_PARENT_PATH="$MODPATH/system/bin"
SCRIPT_NAME="smooth_tweaks"
SCRIPT_PATH="$SCRIPT_PARENT_PATH/$SCRIPT_NAME"

# Set what you want to be displayed on header of installation process

unzip -o "$ZIPFILE" 'addon/*' -d $TMPDIR >&2

# INIT 
# The following is the default implementation: extract $ZIPFILE/system to $MODPATH
# Extend/change the logic to whatever you want
$BOOTMODE || abort "[!] Smooth tweaks cannot be installed in recovery, flash to magisk."

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $SCRIPT_PATH root root 0777 0755
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm_recursive $MODPATH/script 0 0 0755 0755
  set_perm_recursive $MODPATH/bin 0 0 0755 0755
  set_perm_recursive $MODPATH/system 0 0 0755 0755
  set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
  set_perm_recursive $MODPATH/system/vendor 0 0 0755 0755
  set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0755
}

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh
