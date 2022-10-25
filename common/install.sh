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
ui_print "🔹 Installing module..."
ui_print ""

sleep 1

ui_print ""
ui_print "🔹 Running Fstrim, Please wait..."
ui_print ""

fstrim -v /data
fstrim -v /system
fstrim -v /cache

sleep 0.5

ui_print ""
ui_print "📂 Extracting module files"
ui_print ""

unzip -o "$ZIPFILE" 'profiles/*' -d $MODPATH >&2

# Check for existence of /system/xbin directory.
if [[ ! -d "/sbin/.magisk/mirror/system/xbin" ]]; then
  # Use /system/bin instead of /system/xbin.
  mkdir -p "$MODPATH/system/bin"
  mv "$MODPATH/system/xbin/sqlite3" "$MODPATH/system/bin"
  rmdir "$MODPATH/system/xbin"
  ui_print "🔹 SQLite installed successfully... ☑️"
  ui_print ""
else
  ui_print "🔸 SQLite not installed ❌ "
  ui_print ""
fi

[[ "$(getprop ro.miui.ui.version.name)" ]] && miui=true

if [[ "$miui" == "true" ]]; then
  ui_print "🔸 Aosp graphics composter not installed ❌"
else
  unzip -o "$ZIPFILE" 'system/vendor/etc/init/*' -d $MODPATH >&2
  ui_print "🔹 Aosp graphics composter installed successfully... ☑️"
fi

sleep 1

ui_print "----------------------------------------------------------------"
ui_print "             🔹 Select profile by default !"
ui_print ""
ui_print " • Balanced - more optimizarion [Recomended]"
ui_print " • Powersave - more batery autonomy, but reduces performance"
sleep 0.5
ui_print ""
ui_print "✏️ ️Volume + = Switch option / Volume – = Select option"
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
ui_print "🔹 Selected: $TEXT1 ☑️"
ui_print ""

ui_print "⏳ Please, Wait..."

sleep 0.5

if [[ "$TEXT1" == "Balanced" ]]; then
  mv -f "$MODPATH/system/bin/balance" "$MODPATH/system/bin/default_profile"
  rm -rf "$MODPATH/system/bin/powersave"
elif [[ "$TEXT1" == "Powersave" ]]; then
  mv -f "$MODPATH/system/bin/powersave" "$MODPATH/system/bin/default_profile"
  rm -rf "$MODPATH/system/bin/balance"
fi

ui_print ""
ui_print "🔹 $TEXT1 profile activated by default"
ui_print ""
ui_print "🔹 Resolving conflicting modules"
ui_print ""

[[ -d "${moddir}/sqlite3stable" ]] && {
  ui_print "🔸 You have SQLite is installed, disabled, SQLite is already built into this module."
  touch $moddir/sqlite3stable/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/injector" ]] && {
  ui_print "🔸 You have NFS injector Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/injector/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/BulletAimGyro" ]] && {
  ui_print "🔸 You have STRP x Bag Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/BulletAimGyro/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/PXT" ]] && {
  ui_print "🔸 You have Project Extreme Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/PXT/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/xload" ]] && {
  ui_print "🔸 You have Xload is installed, disabled it to avoid conflicts."
  touch $moddir/xload/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/Extreme" ]] && {
  ui_print "🔸 You have Extreme Gaming is installed, disabled it to avoid conflicts."
  touch $moddir/Extreme/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/GPUPerformanceXSeries" ]] && {
  ui_print "🔸 You have Gpu performance X series is installed, disabled it to avoid conflicts."
  touch $moddir/GPUPerformanceXSeries/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/SkiaGL-Default" ]] && {
  ui_print "🔸 You have SkiaGl Default is installed, disabled it to avoid conflicts."
  touch $moddir/SkiaGL-Default/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/SystemOptimization" ]] && {
  ui_print "🔸 You have Leudart Tweaks is installed, disabled it to avoid conflicts.."
  touch $moddir/SystemOptimization/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/onfiretweaks" ]] && {
  ui_print "🔸 You have 𝙊𝙣𝙁𝙞𝙧𝙚 𝙏𝙬𝙚𝙖𝙠𝙨 is installed, disabled it to avoid conflicts."
  touch $moddir/onfiretweaks/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/YAKT" ]] && {
  ui_print "🔸 You have YAKT is installed, disabled it to avoid conflicts."
  touch $moddir/YAKT/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/GPUTurboBoost" ]] && {
  ui_print "🔸 You have GPU Turbo Boost is installed, disabled it to avoid conflicts."
  touch $moddir/GPUTurboBoost/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/injector" ]] && {
  ui_print "🔸 You have Raven's injector is installed, disabled it to avoid conflicts."
  touch $moddir/injector/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/hotplug" ]] && {
  ui_print "🔸 You have Hotplug disabler is installed, disabled it to avoid conflicts."
  touch $moddir/hotplug/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/skiagloptimization" ]] && {
  ui_print "🔸 You have SkiaGl optimization is installed, disabled it to avoid conflicts."
  touch $moddir/skiagloptimization/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/GamersExtreme" ]] && {
  ui_print "🔸 You have Gaymers Extreme (trash) is installed, please remove it."
  touch $moddir/GamersExtreme/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/zeetaatweaks" ]] && {
  ui_print "🔸 You have Zeeta Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/zeetaatweaks/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/aosp_enhancer" ]] && {
  ui_print "🔸 You have AOSP Ecnhance is installed, disabled it to avoid conflicts."
  touch $moddir/aosp_enhancer/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/memeui_enhancer" ]] && {
  ui_print "🔸 You have MIUI Ecnhance is installed, disabled it to avoid conflicts."
  touch $moddir/memeui_enhancer/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/adrenotweaks" ]] && {
  ui_print "🔸 You have Adreno GPU Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/adrenotweaks/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/gpubuffercountkecil" ]] && {
  ui_print "🔸 You have GPU buffer count Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/gpubuffercountkecil/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/FrameBuffer" ]] && {
  ui_print "🔸 You have FrameBuffer is installed, disabled it to avoid conflicts."
  touch $moddir/FrameBuffer/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/ZTS" ]] && {
  ui_print "🔸 You have Zeeta Tweaks is installed, disabled it to avoid conflicts."
  touch $moddir/ZTS/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/fkm_spectrum_injector" ]] && {
  ui_print "🔸 You have FKM Injector is installed, disabled it to avoid conflicts."
  touch $moddir/fkm_spectrum_injector/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/NetworkTweak" ]] && {
  ui_print "🔸 You have Network Tweak (trash) module is installed, disabled it to avoid conflicts."
  touch $moddir/NetworkTweak/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/MAGNETAR" ]] && {
  ui_print "🔸 You have Magnetar is installed, disabled it to avoid conflicts."
  touch $moddir/MAGNETAR/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/MAGNE" ]] && {
  ui_print "🔸 You have Magnetar is installed, disabled it to avoid conflicts."
  touch $moddir/MAGNE/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/FDE" ]] && {
  ui_print "🔸 You have FDE module is installed, disabled it to avoid conflicts."
  touch $moddir/FDE/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ "$(pm list package feravolt)" ]] && {
  ui_print "🔸 You have FDE.ai is installed, delete it to avoid conflicts."
  ui_print ""
}

[[ -d "${moddir}/ktweak" ]] && {
  ui_print "🔸 You have KTweak is installed, disabled it to avoid conflicts."
  touch $moddir/ktweak/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/lspeed" ]] && {
  ui_print "🔸 You have LSpeed is installed, disabled it to avoid conflicts."
  touch $moddir/lspeed/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ "$(pm list package magnetarapp)" ]] && {
  ui_print "🔸 You have Magnetar is installed, disabled it to avoid conflicts."
  ui_print ""
}

[[ -d "${moddir}/sqinjector" ]] && {
  ui_print "🔸 You have SQ Injector is installed, disabled it to avoid conflicts."
  touch $moddir/sqinjector/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/nexus" ]] && {
  ui_print "🔸 You have Nexus module is installed, disabled it to avoid conflicts."
  touch $moddir/nexus/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ -d "${moddir}/flushram" ]] && {
  ui_print "🔸 You have Flush RAM module is installed, disabled it to avoid conflicts."
  touch $moddir/flushram/disable
  ui_print " 🚫 Disabled"
  ui_print ""
}

[[ "$(pm list package nfsmanager)" ]] && {
  ui_print "🔸 You have NFS injector is installed, delete it to avoid conflicts."
  su -c pm disable com.nfs.nfsmanager
  ui_print " 🚫 Disabled app"
  ui_print ""
}

[[ "$(pm list package ktweak)" ]] && {
  ui_print "🔸 You have KTweak is installed, delete it to avoid conflicts."
  su -c pm disable com.draco.ktweak
  ui_print " 🚫 Disabled app"
  ui_print ""
}

[[ "$(pm list package lsandroid)" ]] && {
  ui_print "🔸 You have LSpeed is installed, delete it to avoid conflicts."
  su -c pm disable com.paget96.lsandroid
  ui_print " 🚫 Disabled app"
  ui_print ""
}

sleep 1

ui_print ""
ui_print "----------------------------------------------------------------"
ui_print "       🔹 Do you want to Disable thermal-engine?"
ui_print ""
ui_print "                 🔥 Gamers be like 🔥"
ui_print "               ❗️Only for SnapDragon❗️"
ui_print ""
ui_print "✏️ Volume + = Switch option / Volume – = Select option"
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
ui_print "🔹 Selected: $TEXT2 ☑️"
ui_print ""

ui_print "⏳ Please, Wait..."

if [[ $TEXT2 == "Yes" ]]; then
  unzip -o "$ZIPFILE" 'system/vendor/bin/*' -d $MODPATH >&2
  ui_print "🔹 Thermals have been uploaded 🔥"
  ui_print ""
  ui_print "🔹 Resolution of conflicting thermal modules"
  ui_print ""
  
  [[ -d "${moddir}/smooth_thermals" ]] && {
  ui_print "🔸 You have Smooth Thermal is installed, delete old module after reboot."
  touch $moddir/smooth_thermals/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/ZyCMiThermald" ]] && {
  ui_print "🔸 You have Mi Thermald disabler is installed, disabled it to avoid conflicts."
  touch $moddir/ZyCMiThermald/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/adreno-team-exclusive-thermals" ]] && {
  ui_print "🔸 You have Adreno thermals is installed, disabled it to avoid conflicts."
  touch $moddir/adreno-team-exclusive-thermals/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/SD865" ]] && {
  ui_print "🔸 You have No junk thermals is installed, disabled it to avoid conflicts."
  touch $moddir/SD865/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/SD855" ]] && {
  ui_print "🔸 You have Thermal unlocker 855 is installed, disabled it to avoid conflicts."
  touch $moddir/SD855/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/SD860" ]] && {
  ui_print "🔸 You have Thermal-X Expert is installed, disabled it to avoid conflicts."
  touch $moddir/SD860/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/thermods_rvns" ]] && {
  ui_print "🔸 You have Thermode by rawens is installed, disabled it to avoid conflicts."
  touch $moddir/thermods_rvns/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
  
  [[ -d "${moddir}/tengine" ]] && {
  ui_print "🔸 You have T Engine is installed, disabled it to avoid conflicts."
  touch $moddir/tengine/disable
  ui_print " 🚫 Disabled"
  ui_print ""
  }
elif [[ $TEXT2 == "No" ]]; then
  rm -rf "$MODPATH/system/vendor"
fi

sleep 1

ui_print ""
ui_print " Notes 📝"
ui_print ""
ui_print ""
ui_print "🔹 Reboot is required"
sleep 0.2
ui_print ""
ui_print "🔹 Report issues to Smooth team Chat on Telegram"
sleep 0.2
ui_print ""
ui_print "✨ Join @SMOOTH_team on Telegram to get more updates"
sleep 0.2
ui_print ""
ui_print "🔹 You can find me @DESIRE_TM at Telegram for direct support"
ui_print ""

sleep 1

ui_print ""
ui_print "🔹 Reboot to finish ❗"
ui_print ""