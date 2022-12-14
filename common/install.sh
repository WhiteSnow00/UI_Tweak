awk '{print}' "$MODPATH"/smooth_banner

modver=$(grep_prop version $TMPDIR/module.prop)
modname=$(grep_prop name $TMPDIR/module.prop)
modauthor=$(grep_prop author $TMPDIR/module.prop)
moddir="/data/adb/modules"

ui_print "----------------------------------------------------------------"
ui_print " Name $modname"
ui_print " Current version $modver"
ui_print " Author $modauthor"
ui_print "----------------------------------------------------------------"

sleep 0.5

ui_print ""
ui_print "ð¹ Installing module..."
ui_print ""

sleep 1

ui_print ""
ui_print "ð¹ Running Fstrim, Please wait..."
ui_print ""

fstrim -v /data
fstrim -v /system
fstrim -v /cache

sleep 0.5

ui_print ""
ui_print "ð Extracting module files"
ui_print ""

unzip -o "$ZIPFILE" 'profiles/*' -d $MODPATH >&2

# Check for existence of /system/xbin directory.
if [[ ! -d "/sbin/.magisk/mirror/system/xbin" ]]; then
  # Use /system/bin instead of /system/xbin.
  mkdir -p "$MODPATH/system/bin"
  mv "$MODPATH/system/xbin/sqlite3" "$MODPATH/system/bin"
  rmdir "$MODPATH/system/xbin"
  ui_print "ð¹ SQLite installed successfully... âï¸"
  ui_print ""
else
  ui_print "ð¸ SQLite not installed â "
  ui_print ""
fi

[[ "$(getprop ro.miui.ui.version.name)" ]] && miui=true

if [[ "$miui" == "true" ]]; then
  ui_print "ð¸ Aosp graphics composter not installed â"
else
  unzip -o "$ZIPFILE" 'system/vendor/etc/init/*' -d $MODPATH >&2
  ui_print "ð¹ Aosp graphics composter installed successfully... âï¸"
fi

sleep 1

ui_print "----------------------------------------------------------------"
ui_print "             ð¹ Select profile by default !"
ui_print ""
ui_print " â¢ Balanced - more optimizarion [Recomended]"
ui_print " â¢ Powersave - more batery autonomy, but reduces performance"
sleep 0.5
ui_print ""
ui_print "âï¸ ï¸Volume + = Switch option / Volume â = Select option"
ui_print "----------------------------------------------------------------"
ui_print "                   1 = Yes / 2 = No"
ui_print "----------------------------------------------------------------"
ui_print ""
PROFILES=1
while true; do
  ui_print "      $PROFILES"
  if $VKSEL; then
    PROFILES=$((PROFILES + 1))
  else
	break
  fi
  if [ $PROFILES -gt 2 ]; then
    PROFILES=1
  fi
done

case $PROFILES in
1) TEXT1="Balanced";;
2) TEXT1="Powersave";;
esac

ui_print ""
ui_print "ð¹ Selected: $TEXT1 âï¸"
ui_print ""

ui_print "â³ Please, Wait..."

sleep 0.5

if [[ "$TEXT1" == "Balanced" ]]; then
  mv -f "$MODPATH/system/bin/balance" "$MODPATH/system/bin/default_profile"
  rm -rf "$MODPATH/system/bin/powersave"
elif [[ "$TEXT1" == "Powersave" ]]; then
  mv -f "$MODPATH/system/bin/powersave" "$MODPATH/system/bin/default_profile"
  rm -rf "$MODPATH/system/bin/balance"
fi

ui_print ""
ui_print "ð¹ $TEXT1 profile activated by default"
ui_print ""
ui_print "ð¹ Resolving conflicting modules"
ui_print ""

[[ -d "${moddir}/sqlite3stable" ]] && {
  ui_print "ð¸ You have SQLite is installed, disabled, SQLite is already built into this module."
  touch $moddir/sqlite3stable/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/injector" ]] && {
  ui_print "ð¸ You have NFS injector Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/injector/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/BulletAimGyro" ]] && {
  ui_print "ð¸ You have STRP x Bag Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/BulletAimGyro/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/PXT" ]] && {
  ui_print "ð¸ You have Project Extreme Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/PXT/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/xload" ]] && {
  ui_print "ð¸ You have Xload is installed, disabled it to avoid conflicts."
  touch $moddir/xload/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/Extreme" ]] && {
  ui_print "ð¸ You have Extreme Gaming is installed, disabled it to avoid conflicts."
  touch $moddir/Extreme/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/GPUPerformanceXSeries" ]] && {
  ui_print "ð¸ You have Gpu performance X series is installed, disabled it to avoid conflicts."
  touch $moddir/GPUPerformanceXSeries/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/SkiaGL-Default" ]] && {
  ui_print "ð¸ You have SkiaGl Default is installed, disabled it to avoid conflicts."
  touch $moddir/SkiaGL-Default/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/SystemOptimization" ]] && {
  ui_print "ð¸ You have Leudart Tweaks is installed, disabled it to avoid conflicts.."
  touch $moddir/SystemOptimization/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/onfiretweaks" ]] && {
  ui_print "ð¸ You have ðð£ððð§ð ðð¬ððð ð¨ is installed, disabled it to avoid conflicts."
  touch $moddir/onfiretweaks/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/YAKT" ]] && {
  ui_print "ð¸ You have YAKT is installed, disabled it to avoid conflicts."
  touch $moddir/YAKT/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/GPUTurboBoost" ]] && {
  ui_print "ð¸ You have GPU Turbo Boost is installed, disabled it to avoid conflicts."
  touch $moddir/GPUTurboBoost/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/injector" ]] && {
  ui_print "ð¸ You have Raven's injector is installed, disabled it to avoid conflicts."
  touch $moddir/injector/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/hotplug" ]] && {
  ui_print "ð¸ You have Hotplug disabler is installed, disabled it to avoid conflicts."
  touch $moddir/hotplug/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/skiagloptimization" ]] && {
  ui_print "ð¸ You have SkiaGl optimization is installed, disabled it to avoid conflicts."
  touch $moddir/skiagloptimization/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/GamersExtreme" ]] && {
  ui_print "ð¸ You have Gaymers Extreme (trash) is installed, please remove it."
  touch $moddir/GamersExtreme/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/zeetaatweaks" ]] && {
  ui_print "ð¸ You have Zeeta Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/zeetaatweaks/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/aosp_enhancer" ]] && {
  ui_print "ð¸ You have AOSP Ecnhance is installed, disabled it to avoid conflicts."
  touch $moddir/aosp_enhancer/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/memeui_enhancer" ]] && {
  ui_print "ð¸ You have MIUI Ecnhance is installed, disabled it to avoid conflicts."
  touch $moddir/memeui_enhancer/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/adrenotweaks" ]] && {
  ui_print "ð¸ You have Adreno GPU Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/adrenotweaks/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/gpubuffercountkecil" ]] && {
  ui_print "ð¸ You have GPU buffer count Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/gpubuffercountkecil/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/FrameBuffer" ]] && {
  ui_print "ð¸ You have FrameBuffer is installed, disabled it to avoid conflicts."
  touch $moddir/FrameBuffer/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/ZTS" ]] && {
  ui_print "ð¸ You have Zeeta Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/ZTS/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/fkm_spectrum_injector" ]] && {
  ui_print "ð¸ You have FKM Injector is installed, disabled it to avoid conflicts."
  touch $moddir/fkm_spectrum_injector/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/NetworkTweak" ]] && {
  ui_print "ð¸ You have Network Tweak (trash) module is installed, disabled it to avoid conflicts."
  touch $moddir/NetworkTweak/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/MAGNETAR" ]] && {
  ui_print "ð¸ You have Magnetar is installed, disabled it to avoid conflicts."
  touch $moddir/MAGNETAR/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/MAGNE" ]] && {
  ui_print "ð¸ You have Magnetar is installed, disabled it to avoid conflicts."
  touch $moddir/MAGNE/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/FDE" ]] && {
  ui_print "ð¸ You have FDE module is installed, disabled it to avoid conflicts."
  touch $moddir/FDE/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ "$(pm list package feravolt)" ]] && {
  ui_print "ð¸ You have FDE.ai is installed, delete it to avoid conflicts."
  ui_print ""
}

[[ -d "${moddir}/ktweak" ]] && {
  ui_print "ð¸ You have KTweak is installed, disabled it to avoid conflicts."
  touch $moddir/ktweak/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/lspeed" ]] && {
  ui_print "ð¸ You have LSpeed is installed, disabled it to avoid conflicts."
  touch $moddir/lspeed/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ "$(pm list package magnetarapp)" ]] && {
  ui_print "ð¸ You have Magnetar is installed, disabled it to avoid conflicts."
  ui_print ""
}

[[ -d "${moddir}/sqinjector" ]] && {
  ui_print "ð¸ You have SQ Injector is installed, disabled it to avoid conflicts."
  touch $moddir/sqinjector/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/nexus" ]] && {
  ui_print "ð¸ You have Nexus module is installed, disabled it to avoid conflicts."
  touch $moddir/nexus/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ -d "${moddir}/flushram" ]] && {
  ui_print "ð¸ You have Flush RAM module is installed, disabled it to avoid conflicts."
  touch $moddir/flushram/disable
  ui_print " ð« Disabled"
  ui_print ""
}

[[ "$(pm list package nfsmanager)" ]] && {
  ui_print "ð¸ You have NFS injector is installed, delete it to avoid conflicts."
  su -c pm disable com.nfs.nfsmanager
  ui_print " ð« Disabled app"
  ui_print ""
}

[[ "$(pm list package ktweak)" ]] && {
  ui_print "ð¸ You have KTweak is installed, delete it to avoid conflicts."
  su -c pm disable com.draco.ktweak
  ui_print " ð« Disabled app"
  ui_print ""
}

[[ "$(pm list package lsandroid)" ]] && {
  ui_print "ð¸ You have LSpeed is installed, delete it to avoid conflicts."
  su -c pm disable com.paget96.lsandroid
  ui_print " ð« Disabled app"
  ui_print ""
}

sleep 1

ui_print ""
ui_print "----------------------------------------------------------------"
ui_print "       ð¹ Do you want to Disable thermal-engine?"
ui_print ""
ui_print "                 ð¥ Gamers be like ð¥"
ui_print "               âï¸Only for SnapDragonâï¸"
ui_print ""
ui_print "âï¸ Volume + = Switch option / Volume â = Select option"
ui_print ""
ui_print "----------------------------------------------------------------"
ui_print "                   1 = Yes / 2 = No"
ui_print "----------------------------------------------------------------"
ui_print ""
THERMALS=1
while true; do
  ui_print "      $THERMALS"
  if $VKSEL; then
    THERMALS=$((THERMALS + 1))
  else
	break
  fi
  if [ $THERMALS -gt 2 ]; then
    THERMALS=1
  fi
done

case $THERMALS in
1) TEXT2="Yes";;
2) TEXT2="No";;
esac

ui_print ""
ui_print "ð¹ Selected: $TEXT2 âï¸"
ui_print ""

ui_print "â³ Please, Wait..."

if [[ $TEXT2 == "Yes" ]]; then
  unzip -o "$ZIPFILE" 'system/vendor/bin/*' -d $MODPATH >&2
  ui_print "ð¹ Thermals have been uploaded ð¥"
  ui_print ""
  ui_print "ð¹ Resolution of conflicting thermal modules"
  ui_print ""
  
  [[ -d "${moddir}/smooth_thermals" ]] && {
  ui_print "ð¸ You have Smooth Thermal is installed, delete old module after reboot."
  touch $moddir/smooth_thermals/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/ZyCMiThermald" ]] && {
  ui_print "ð¸ You have Mi Thermald disabler is installed, disabled it to avoid conflicts."
  touch $moddir/ZyCMiThermald/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/adreno-team-exclusive-thermals" ]] && {
  ui_print "ð¸ You have Adreno thermals is installed, disabled it to avoid conflicts."
  touch $moddir/adreno-team-exclusive-thermals/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/SD865" ]] && {
  ui_print "ð¸ You have No junk thermals is installed, disabled it to avoid conflicts."
  touch $moddir/SD865/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/SD855" ]] && {
  ui_print "ð¸ You have Thermal unlocker 855 is installed, disabled it to avoid conflicts."
  touch $moddir/SD855/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/SD860" ]] && {
  ui_print "ð¸ You have Thermal-X Expert is installed, disabled it to avoid conflicts."
  touch $moddir/SD860/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/thermods_rvns" ]] && {
  ui_print "ð¸ You have Thermode by rawens is installed, disabled it to avoid conflicts."
  touch $moddir/thermods_rvns/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/tengine" ]] && {
  ui_print "ð¸ You have T Engine is installed, disabled it to avoid conflicts."
  touch $moddir/tengine/disable
  ui_print " ð« Disabled"
  ui_print ""
  }
elif [[ $TEXT2 == "No" ]]; then
  rm -rf "$MODPATH/system/vendor"
fi

sleep 1

ui_print ""
ui_print " Notes ð"
ui_print ""
ui_print ""
ui_print "ð¹ Reboot is required"
sleep 0.2
ui_print ""
ui_print "ð¹ Report issues to Smooth team Chat on Telegram"
sleep 0.2
ui_print ""
ui_print "â¨ Join @SMOOTH_team on Telegram to get more updates"
sleep 0.2
ui_print ""
ui_print "ð¹ You can find me @DESIRE_TM at Telegram for direct support"
ui_print ""

sleep 1

ui_print ""
ui_print "ð¹ Reboot to finish â"
ui_print ""