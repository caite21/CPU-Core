
set_msg_config -severity INFO -suppress

# Run behavioral simulations
puts "\nStarting pm"
launch_simulation -simset [get_filesets sim_pm ] 
close_sim

puts "\nStarting rf"
launch_simulation -simset [get_filesets sim_rf ]
close_sim

puts "\nStarting alu"
launch_simulation -simset [get_filesets sim_alu ]
close_sim

puts "\nStarting datpath"
launch_simulation -simset [get_filesets sim_dp ]
close_sim

puts "\nStarting control_unit"
launch_simulation -simset [get_filesets sim_cu ]
close_sim

puts "\nStarting cpu_core"
launch_simulation -simset [get_filesets sim_cpu_core ]
close_sim

reset_msg_config -severity INFO -suppress

puts "\n\nSimulation complete for all testbenches\n"
