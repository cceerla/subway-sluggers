# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 1
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.cache/wt [current_project]
set_property parent.project_path C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/sources_1/imports/new/15_bit_counter.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/sources_1/imports/new/edge_detector.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/game_fsm.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/sources_1/imports/new/hex_7_seg.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/hover_bar.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/sources_1/new/init.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/Downloads/labVGA_clks.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/new/mux.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/new/random_number_generator.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/sources_1/imports/new/ring_counter.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/sources_1/imports/new/selector.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/shape.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/slug_fsm.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/slug_pos_manager.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/imports/new/synchronizer.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/timer.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/train_fsm.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/vga_display.v
  C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/sources_1/new/lab_6.v
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/constrs_1/imports/Downloads/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/cceerla/Downloads/lab_6.xpr/lab_6/lab_6.srcs/constrs_1/imports/Downloads/Basys3_Master.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top lab_6 -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef lab_6.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file lab_6_utilization_synth.rpt -pb lab_6_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
