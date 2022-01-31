onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {CLK & RST} -color Magenta -radix binary /memory_control_tb/CLK
add wave -noupdate -expand -group {CLK & RST} -color Magenta -radix binary /memory_control_tb/nRST
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} {/memory_control_tb/PROG/ccif/iwait[0]}
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} {/memory_control_tb/PROG/ccif/dwait[0]}
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} {/memory_control_tb/PROG/ccif/iREN[0]}
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} {/memory_control_tb/PROG/ccif/dREN[0]}
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} {/memory_control_tb/PROG/ccif/dWEN[0]}
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} /memory_control_tb/PROG/ccif/ramWEN
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} /memory_control_tb/PROG/ccif/ramREN
add wave -noupdate -expand -group {Main Control Signals} -color {Medium Violet Red} /memory_control_tb/PROG/ccif/ramstate
add wave -noupdate -expand -group {Address Lines} -color Salmon {/memory_control_tb/PROG/ccif/iaddr[0]}
add wave -noupdate -expand -group {Address Lines} -color Salmon /memory_control_tb/ccif/ramaddr
add wave -noupdate -expand -group {Address Lines} -color Salmon {/memory_control_tb/PROG/ccif/daddr[0]}
add wave -noupdate -expand -group {Data Lines} -color Yellow {/memory_control_tb/PROG/ccif/iload[0]}
add wave -noupdate -expand -group {Data Lines} -color Yellow {/memory_control_tb/PROG/ccif/dload[0]}
add wave -noupdate -expand -group {Data Lines} -color Yellow {/memory_control_tb/PROG/ccif/dstore[0]}
add wave -noupdate -expand -group {Data Lines} -color Yellow /memory_control_tb/PROG/ccif/ramstore
add wave -noupdate -expand -group {Data Lines} -color Yellow /memory_control_tb/PROG/ccif/ramload
add wave -noupdate -expand -group {CC Signals} {/memory_control_tb/PROG/ccif/ccwait[0]}
add wave -noupdate -expand -group {CC Signals} {/memory_control_tb/PROG/ccif/ccinv[0]}
add wave -noupdate -expand -group {CC Signals} {/memory_control_tb/PROG/ccif/ccwrite[0]}
add wave -noupdate -expand -group {CC Signals} {/memory_control_tb/PROG/ccif/cctrans[0]}
add wave -noupdate -expand -group {CC Signals} {/memory_control_tb/PROG/ccif/ccsnoopaddr[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {140 ns}
