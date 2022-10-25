#!/system/bin/sh

# ----------------------
# SMOOTH TWEAKS 💕 
# Author: @DESIRE_TM🥀
# ----------------------

echo
echo "🔹 Powersave "
echo

# Maximum unsigned integer size in C
UINT_MAX="4294967295"

# ---------------------- 
# Basic tool functions
# ---------------------- 
# Safely write value to file
write() {
  # Bail out if file does not exist
  if [[ ! -e "$2" ]]; then
    echo "🔸Error $1 --> $2"
	return 1
  fi
	
  current=$(cat "$2")

	# Bail out if value is already set
  if [[ "$current" == "$1" ]]; then
    echo "🔹Success: $current --> $1 $2"
	return 0
  fi

  # Write the new value
  chmod 0666 "$2" 2>/dev/null
  echo "$1" > "$2"

  # Bail out if write fails
  if [[ $? -ne 0 ]]; then
    echo "🔸Failed set $1 to $2"
	return 1
  fi

  echo "🔹Success: $current --> $1 $2"
  
  # Guide: Write $1 = Value | $2 = Task/Directory
}

# ----------------------
# Main script
# ----------------------

# GPU settings
for gpu in /sys/class/kgsl/kgsl-3d0; do
  write "0" $gpu/max_pwrlevel
  write "0" $gpu/adrenoboost
  write "1" $gpu/throttling
  write "1" $gpu/bus_split
  write "0" $gpu/force_clk_on
  write "0" $gpu/force_bus_on
  write "0" $gpu/force_rail_on
  write "0" $gpu/force_no_nap
  write "16" $gpu/devfreq/polling_interval
  write "80" $gpu/idle_timer
  write "3" $gpu/min_pwrlevel
done

# Swith gpu governor
if grep 'userspace' /sys/class/kgsl/kgsl-3d0/devfreq/available_governors; then
  write 'userspace' /sys/class/kgsl/kgsl-3d0/devfreq/governor
elif grep 'msm-adreno-tz' /sys/class/kgsl/kgsl-3d0/devfreq/available_governors; then
  write 'msm-adreno-tz' /sys/class/kgsl/kgsl-3d0/devfreq/governor
fi

# Switch governor
if grep "conservative" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
  for cpus in 0 1 2 3 4 5 6 7 8 9; do
    write "conservative" /sys/devices/system/cpu/cpu$cpus/cpufreq/scaling_governor
  done
elif grep "schedutil" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
  write "schedutil" /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  write "schedutil" /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
  write "schedutil" /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
  write "schedutil" /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
elif grep "interactive" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
  write "interactive" /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  write "interactive" /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
  write "interactive" /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
  write "interactive" /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
  write "powersave" /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
fi

# Adreno idler
if [[ -e /sys/module/adreno_idler/parameters/adreno_idler_active ]]; then
  write "Y" /sys/module/adreno_idler/parameters/adreno_idler_active
  write "6000" /sys/module/adreno_idler/parameters/adreno_idler_idleworkload
  write "15" /sys/module/adreno_idler/parameters/adreno_idler_downdifferential
  write "15" /sys/module/adreno_idler/parameters/adreno_idler_idlewait
fi

# Enable multi core power saving
mcps="/sys/devices/system/cpu/sched_mc_power_savings"
if [[ -e "$mcps" ]]; then
  write "1" $mcps
fi

# Limit thermal ignore
glti=/proc/gpufreq/gpufreq_limited_thermal_ignore
if [[ -e "$glti" ]]; then
  write "0" $glti
fi

# FileSystem
write "50" /proc/sys/fs/lease-break-time

# Stuneboost
write "0" /dev/stune/top-app/schedtune.boost

# Set up for kernel sched
for sched_kernel in /proc/sys/kernel; do
  write "0" $sched_kernel/sched_boost
  write "0" $sched_kernel/timer_migration
  write "0" $sched_kernel/sched_tunable_scaling
  write "0" $sched_kernel/sched_child_runs_first
  write "1" $sched_kernel/sched_autogroup_enabled
  write "5" $sched_kernel/perf_cpu_time_max_percent
  write "32" $sched_kernel/sched_nr_migrate
  write "50" $sched_kernel/sched_min_task_util_for_colocation
done

# Virtual memory
for virtual_memory in /proc/sys/vm; do
  write "20" $virtual_memory/stat_interval
  write "1000" $virtual_memory/dirty_expire_centisecs
  write "500" $virtual_memory/dirty_writeback_centisecs
done

# I/O
for scheduler in /sys/block/sd*/queue; do
  write "noop" $scheduler/scheduler
  write "128" $scheduler/read_ahead_kb
  write "64" $scheduler/nr_requests
  write "1" $scheduler/rq_affinity
  write "0" $scheduler/nomerges
done

# Loop
for loop in /sys/block/loop*/queue; do
  write "128" $loop/read_ahead_kb
done

# Gaming Touch For Kangaroox
if [[ -e "/sys/devices/virtual/touch/touch_dev/bump_sample_rate" ]]; then
  write "0" /sys/devices/virtual/touch/touch_dev/bump_sample_rate
fi

# Core control 
for hotplug in /sys/devices/system/cpu; do
  write "0" $hotplug/cpu0/core_ctl/enable

  write "1" $hotplug/cpu4/core_ctl/enable
  write "2" $hotplug/cpu4/core_ctl/min_cpus
  write "60" $hotplug/cpu4/core_ctl/busy_up_thres
  write "30" $hotplug/cpu4/core_ctl/busy_down_thres
  write "100" $hotplug/cpu4/core_ctl/offline_delay_ms

  write "1" $hotplug/cpu7/core_ctl/enable
  write "0" $hotplug/cpu7/core_ctl/min_cpus
  write "60" $hotplug/cpu7/core_ctl/busy_up_thres
  write "30" $hotplug/cpu7/core_ctl/busy_down_thres
  write "100" $hotplug/cpu7/core_ctl/offline_delay_ms
done

# Sconfig
write "0" /sys/class/thermal/thermal_message/sconfig

# Gms
su -c pm disable com.google.android.gms/.chimera.GmsIntentOperationService

echo "🔹Done"

# Exit script
exit 0
