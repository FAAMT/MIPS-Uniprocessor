onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Yellow /controlunit_tb/PROG/CLK
add wave -noupdate -color Yellow /controlunit_tb/PROG/nRST
add wave -noupdate -color Yellow /controlunit_tb/PROG/tb_test_case
add wave -noupdate -expand -group {Input Signals} -color White /controlunit_tb/cuif/imemload
add wave -noupdate -expand -group {Input Signals} -color White /controlunit_tb/cuif/negative
add wave -noupdate -expand -group {Input Signals} -color White /controlunit_tb/cuif/zero
add wave -noupdate -expand -group {Input Signals} -color White /controlunit_tb/cuif/overflow
add wave -noupdate -expand -group {Control Signals} /controlunit_tb/cuif/instruction
add wave -noupdate -expand -group {Control Signals} -color Aquamarine /controlunit_tb/cuif/ALUop
add wave -noupdate -expand -group {Control Signals} -color Aquamarine /controlunit_tb/cuif/ALUsrc
add wave -noupdate -expand -group {Control Signals} -color {Light Steel Blue} /controlunit_tb/cuif/WEN
add wave -noupdate -expand -group {Control Signals} -color {Light Steel Blue} /controlunit_tb/cuif/RFWdata
add wave -noupdate -expand -group {Control Signals} /controlunit_tb/cuif/ext
add wave -noupdate -expand -group {Control Signals} -color Violet /controlunit_tb/cuif/MemRead
add wave -noupdate -expand -group {Control Signals} -color Violet /controlunit_tb/cuif/MemWrite
add wave -noupdate -expand -group {Control Signals} -color Red /controlunit_tb/cuif/Branch
add wave -noupdate -expand -group {Control Signals} -color Red /controlunit_tb/cuif/Jump
add wave -noupdate -expand -group {Control Signals} -color Orange /controlunit_tb/cuif/RegDst1
add wave -noupdate -expand -group {Control Signals} -color Orange /controlunit_tb/cuif/RegDst2
add wave -noupdate -expand -group {Control Signals} -color Red /controlunit_tb/cuif/halt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
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
WaveRestoreZoom {0 ns} {42 ns}
