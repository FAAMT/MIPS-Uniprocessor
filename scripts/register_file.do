onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /register_file_tb/CLK
add wave -noupdate /register_file_tb/nRST
add wave -noupdate /register_file_tb/rfif/WEN
add wave -noupdate -radix unsigned /register_file_tb/rfif/wsel
add wave -noupdate -radix unsigned /register_file_tb/rfif/rsel1
add wave -noupdate -radix unsigned /register_file_tb/rfif/rsel2
add wave -noupdate -radix unsigned /register_file_tb/rfif/wdat
add wave -noupdate -radix unsigned /register_file_tb/rfif/rdat1
add wave -noupdate -radix unsigned /register_file_tb/rfif/rdat2
add wave -noupdate -radix unsigned -childformat {{{/register_file_tb/DUT/register[31]} -radix unsigned} {{/register_file_tb/DUT/register[30]} -radix unsigned} {{/register_file_tb/DUT/register[29]} -radix unsigned} {{/register_file_tb/DUT/register[28]} -radix unsigned} {{/register_file_tb/DUT/register[27]} -radix unsigned} {{/register_file_tb/DUT/register[26]} -radix unsigned} {{/register_file_tb/DUT/register[25]} -radix unsigned} {{/register_file_tb/DUT/register[24]} -radix unsigned} {{/register_file_tb/DUT/register[23]} -radix unsigned} {{/register_file_tb/DUT/register[22]} -radix unsigned} {{/register_file_tb/DUT/register[21]} -radix unsigned} {{/register_file_tb/DUT/register[20]} -radix unsigned} {{/register_file_tb/DUT/register[19]} -radix unsigned} {{/register_file_tb/DUT/register[18]} -radix unsigned} {{/register_file_tb/DUT/register[17]} -radix unsigned} {{/register_file_tb/DUT/register[16]} -radix unsigned} {{/register_file_tb/DUT/register[15]} -radix unsigned} {{/register_file_tb/DUT/register[14]} -radix unsigned} {{/register_file_tb/DUT/register[13]} -radix unsigned} {{/register_file_tb/DUT/register[12]} -radix unsigned} {{/register_file_tb/DUT/register[11]} -radix unsigned} {{/register_file_tb/DUT/register[10]} -radix unsigned} {{/register_file_tb/DUT/register[9]} -radix unsigned} {{/register_file_tb/DUT/register[8]} -radix unsigned} {{/register_file_tb/DUT/register[7]} -radix unsigned} {{/register_file_tb/DUT/register[6]} -radix unsigned} {{/register_file_tb/DUT/register[5]} -radix unsigned} {{/register_file_tb/DUT/register[4]} -radix unsigned} {{/register_file_tb/DUT/register[3]} -radix unsigned} {{/register_file_tb/DUT/register[2]} -radix unsigned} {{/register_file_tb/DUT/register[1]} -radix unsigned} {{/register_file_tb/DUT/register[0]} -radix unsigned}} -expand -subitemconfig {{/register_file_tb/DUT/register[31]} {-radix unsigned} {/register_file_tb/DUT/register[30]} {-radix unsigned} {/register_file_tb/DUT/register[29]} {-radix unsigned} {/register_file_tb/DUT/register[28]} {-radix unsigned} {/register_file_tb/DUT/register[27]} {-radix unsigned} {/register_file_tb/DUT/register[26]} {-radix unsigned} {/register_file_tb/DUT/register[25]} {-radix unsigned} {/register_file_tb/DUT/register[24]} {-radix unsigned} {/register_file_tb/DUT/register[23]} {-radix unsigned} {/register_file_tb/DUT/register[22]} {-radix unsigned} {/register_file_tb/DUT/register[21]} {-radix unsigned} {/register_file_tb/DUT/register[20]} {-radix unsigned} {/register_file_tb/DUT/register[19]} {-radix unsigned} {/register_file_tb/DUT/register[18]} {-radix unsigned} {/register_file_tb/DUT/register[17]} {-radix unsigned} {/register_file_tb/DUT/register[16]} {-radix unsigned} {/register_file_tb/DUT/register[15]} {-radix unsigned} {/register_file_tb/DUT/register[14]} {-radix unsigned} {/register_file_tb/DUT/register[13]} {-radix unsigned} {/register_file_tb/DUT/register[12]} {-radix unsigned} {/register_file_tb/DUT/register[11]} {-radix unsigned} {/register_file_tb/DUT/register[10]} {-radix unsigned} {/register_file_tb/DUT/register[9]} {-radix unsigned} {/register_file_tb/DUT/register[8]} {-radix unsigned} {/register_file_tb/DUT/register[7]} {-radix unsigned} {/register_file_tb/DUT/register[6]} {-radix unsigned} {/register_file_tb/DUT/register[5]} {-radix unsigned} {/register_file_tb/DUT/register[4]} {-radix unsigned} {/register_file_tb/DUT/register[3]} {-radix unsigned} {/register_file_tb/DUT/register[2]} {-radix unsigned} {/register_file_tb/DUT/register[1]} {-radix unsigned} {/register_file_tb/DUT/register[0]} {-radix unsigned}} /register_file_tb/DUT/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90 ns} 0}
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
WaveRestoreZoom {3 ns} {157 ns}
