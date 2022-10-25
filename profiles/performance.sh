#!/system/bin/sh

# ----------------------
# SMOOTH TWEAKS 💕 
# Author: @DESIRE_TM🥀
# ----------------------

# Maximum unsigned integer size in C
UINT_MAX="4294967295"

# Duration in nanoseconds of one scheduling period
SCHED_PERIOD=$((10 * 1000 * 1000))

# How many tasks should we have at a maximum in one scheduling period
SCHED_TASKS="6"

echo
echo "🔹 Performance "
echo

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
  write "3" $gpu/adrenoboost
  write "0" $gpu/throttling
  write "0" $gpu/bus_split
  write "1" $gpu/force_clk_on
  write "1" $gpu/force_bus_on
  write "1" $gpu/force_rail_on
  write "1" $gpu/force_no_nap
  write "4" $gpu/devfreq/polling_interval
  write "80" $gpu/idle_timer
  write $UINT_MAX $gpu/min_pwrlevel
done

write 'performance' /sys/class/kgsl/kgsl-3d0/devfreq/governor

# Swith governor to performance
if grep "performance" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
  for cpus in 0 1 2 3 4 5 6 7 8 9; do
    write "performance" /sys/devices/system/cpu/cpu$cpus/cpufreq/scaling_governor
  done
fi

# Fs
write "5" /proc/sys/fs/lease-break-time

# Stuneboost
write "5" /dev/stune/top-app/schedtune.boost

# Set up for kernel sched
for sched_kernel in /proc/sys/kernel; do
  write "1" $sched_kernel/sched_boost
  write "0" $sched_kernel/timer_migration
  write "0" $sched_kernel/sched_tunable_scaling
  write "0" $sched_kernel/sched_child_runs_first
  write "0" $sched_kernel/sched_autogroup_enabled
  write "0" $sched_kernel/sched_min_task_util_for_colocation
  write "15" $sched_kernel/perf_cpu_time_max_percent
  write "128" $sched_kernel/sched_nr_migrate
  write $SCHED_PERIOD $sched_kernel/sched_latency_ns
  write $((SCHED_PERIOD/SCHED_TASKS)) $sched_kernel/sched_min_granularity_ns
  write $((SCHED_PERIOD/2)) $sched_kernel/sched_wakeup_granularity_ns
done

# Virtual memory
for virtual_memory in /proc/sys/vm; do
  write "1" $virtual_memory/stat_interval
  write "3000" $virtual_memory/dirty_expire_centisecs
  write "3000" $virtual_memory/dirty_writeback_centisecs
done

# I/O
for scheduler in /sys/block/sd*/queue; do
  write "deadline" $scheduler/scheduler
  write "256" $scheduler/read_ahead_kb
  write "512" $scheduler/nr_requests
  write "8" $scheduler/iosched/fifo_batch
  write "250" $scheduler/iosched/read_expire
  write "2" $scheduler/rq_affinity
  write "2" $scheduler/nomerges
done

# Loop
for loop in /sys/block/loop*/queue; do
  write "256" $loop/read_ahead_kb
done

# Adreno idler
gpuidler="/sys/module/adreno_idler/parameters/adreno_idler_active"
if [[ -e "$gpuidler" ]]; then
  write "N" $gpuidler
fi

# Limit thermal ignore
glti="/proc/gpufreq/gpufreq_limited_thermal_ignore"
if [[ -e "$glti" ]]; then
  write "1" $glti
fi

# Disable Hotplug
for hotplug in /sys/devices/system/cpu/cpu*/core_ctl; do
  write "0" $hotplug/enable
done

# Disable multi core power saving
mcps="/sys/devices/system/cpu/sched_mc_power_savings"
if [[ -e "$mcps" ]]; then
  write "0" $mcps
fi

# Gaming Touch For Kangaroox
if [[ -e "/sys/devices/virtual/touch/touch_dev/bump_sample_rate" ]]; then
  write "1" /sys/devices/virtual/touch/touch_dev/bump_sample_rate
fi

# Sconfig
write "10" /sys/class/thermal/thermal_message/sconfig

# Gms
su -c pm enable com.google.android.gms/.chimera.GmsIntentOperationService

echo "🔹Done"

# Exit script
exit 0