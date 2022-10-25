#!/system/bin/sh

# ----------------------
# Author: @DESIRE_TM🥀
# ----------------------

# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode

# Apply After Boot
wait_until_boot_complete() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 1
  done
}

wait_until_boot_complete

# =========
# Apply My Tweaks
# =========
default_profile

# Exit script
exit 0