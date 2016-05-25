
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name CNC -dir "M:/IS/CNC/planAhead_run_5" -part xc3s500efg320-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "CNC.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {divisor.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {UART_v.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Secuenciador.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Motor.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Assembler.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {CNC.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top CNC $srcset
add_files [list {CNC.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s500efg320-4
