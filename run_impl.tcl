# Runs synthesis and implementation and runs both simulations 
# and logs final result of whether the testbench passed in log.txt.
# Also opens timing summary.


set top_sim "sim_cpu_core"

# Output time to log file
set log_file [open "C:/Users/caite/Documents/VivadoProjects/CPU/log.txt" a]
set current_time [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
puts $log_file "\n$current_time Run Top Synthesis and Implementation"


# Run synthesis then simulation
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_simulation -simset [get_filesets sim_cpu_core ] -mode "post-synthesis" -type "functional" 

close_sim
close_design

# Log whether testbench passed
set temp_log [open "C:/Users/caite/Documents/VivadoProjects/CPU/CPU.sim/$top_sim/synth/func/xsim/simulate.log" r]
set log_data [read $temp_log]
if {[regexp {Testbench Result: .* Passed} $log_data] && ![regexp {(Error|Fatal)} $log_data]} {
    puts $log_file "$current_time $top_sim synth\tPassed"
} else {
    puts $log_file "$current_time $top_sim synth\tFAILED"
}
close $temp_log


# Run implementation then simulation
launch_runs impl_1 -jobs 8
wait_on_run impl_1
launch_simulation -simset [get_filesets sim_cpu_core ] -mode "post-implementation" -type "functional" 

close_sim

# Log whether testbench passed
set temp_log [open "C:/Users/caite/Documents/VivadoProjects/CPU/CPU.sim/$top_sim/impl/func/xsim/simulate.log" r]
set log_data [read $temp_log]
if {[regexp {Testbench Result: .* Passed} $log_data] && ![regexp {(Error|Fatal)} $log_data]} {
    puts $log_file "$current_time $top_sim impl\tPassed"
} else {
    puts $log_file "$current_time $top_sim impl\tFAILED"
}
close $temp_log

report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_1

close $log_file

puts "\n\nSynthesis and Implementation Complete"