#!/system/bin/sh

# ----------------------
# SMOOTH TWEAKS 💕 
# Author: @DESIRE_TM🥀
# ----------------------

echo
echo "🔹 Balanced "
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
  write "N" $gpu/adreno_idler_active
  write "0" $gpu/throttling
  write "0" $gpu/bus_split
  write "0" $gpu/force_clk_on
  write "0" $gpu/force_bus_on
  write "0" $gpu/force_rail_on
  write "1" $gpu/force_no_nap
  write "10" $gpu/devfreq/polling_interval
  write "80" $gpu/idle_timer
  write $UINT_MAX $gpu/min_pwrlevel
done

# Swith gpu governor
if grep 'simple_ondemand' /sys/class/kgsl/kgsl-3d0/devfreq/available_governors; then
  write 'simple_ondemand' /sys/class/kgsl/kgsl-3d0/devfreq/governor
elif grep 'msm-adreno-tz' /sys/class/kgsl/kgsl-3d0/devfreq/available_governors; then
  write 'msm-adreno-tz' /sys/class/kgsl/kgsl-3d0/devfreq/governor
fi

# Switch cpu governor
if grep "schedutil" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
  for cpus in 0 1 2 3 4 5 6 7 8 9; do
    write "schedutil" /sys/devices/system/cpu/cpu$cpus/cpufreq/scaling_governor
  done
elif grep "interactive" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
  for cpus in 0 1 2 3 4 5 6 7 8 9; do
    write "interactive" /sys/devices/system/cpu/cpu$cpus/cpufreq/scaling_governor
  done
fi

# Limit thermal ignore
glti=/proc/gpufreq/gpufreq_limited_thermal_ignore
if [[ -e "$glti" ]]; then
  write "0" $glti
fi

# Set up for kernel sched
for sched_kernel in /proc/sys/kernel; do
  write "0" $sched_kernel/sched_boost
  write "0" $sched_kernel/timer_migration
  write "0" $sched_kernel/sched_tunable_scaling
  write "0" $sched_kernel/sched_child_runs_first
  write "0" $sched_kernel/sched_tunable_scaling
  write "1" $sched_kernel/sched_autogroup_enabled
  write "32" $sched_kernel/sched_nr_migrate
  write "35" $sched_kernel/sched_min_task_util_for_colocation
  write "5" $sched_kernel/perf_cpu_time_max_percent
done

# Virtual memory
for virtual_memory in /proc/sys/vm; do
  write "20" $virtual_memory/stat_interval
  write "3000" $virtual_memory/dirty_expire_centisecs
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

# Stuneboost
write "0" /dev/stune/top-app/schedtune.boost

# Fs
write "20" /proc/sys/fs/lease-break-time

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

# Gms enable
su -c pm enable com.google.android.gms/.chimera.GmsIntentOperationService

echo "🔹Done"

# Exit script
exit 0