onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mine_tb/SHA624/clk
add wave -noupdate /mine_tb/SHA624/reset_n
add wave -noupdate -divider <NULL>
add wave -noupdate /mine_tb/SHA624/data_i
add wave -noupdate /mine_tb/SHA624/digest_o
add wave -noupdate -divider <NULL>
add wave -noupdate /mine_tb/SHA256/data_i
add wave -noupdate /mine_tb/SHA256/digest_o
add wave -noupdate -divider <NULL>
add wave -noupdate /mine_tb/digest_o_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
