# Runs all simulations in the project and prints output to stdout
# and logs final result of whether the testbench passed in log.txt.


# Output time to log file
set log_file [open "C:/Users/caite/Documents/VivadoProjects/CPU/log.txt" a]
set current_time [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
puts $log_file "\n$current_time Run All Simulations"

# Get list of simulation sources
set sim_list [get_filesets sim*]

# Suppress INFO log_files
set_msg_config -severity {INFO} -suppress

# Run all simulations and log final result
for {set i 0} {$i < [llength $sim_list]} {incr i} {
	launch_simulation -simset [get_filesets [lindex $sim_list $i] ] 
	close_sim

	# Log whether testbench passed
	set temp_log [open "C:/Users/caite/Documents/VivadoProjects/CPU/CPU.sim/[lindex $sim_list $i]/behav/xsim/simulate.log" r]
	set log_data [read $temp_log]
	if {[regexp {Testbench Result: .* Passed} $log_data] && ![regexp {(Error|Fatal)} $log_data]} {
	    puts $log_file "$current_time [lindex $sim_list $i]\tPassed"
	} else {
	    puts $log_file "$current_time [lindex $sim_list $i]\tFAILED"
	}
	close $temp_log
}


close $log_file
reset_msg_config -severity {INFO} -suppress

puts "\n\nAll Behavioral Simulations Complete\n"