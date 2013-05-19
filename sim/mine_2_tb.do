onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mine_2_tb/clk
add wave -noupdate /mine_2_tb/reset_n
add wave -noupdate -divider {SHA 640}
add wave -noupdate /mine_2_tb/sha256_640_1/start
add wave -noupdate /mine_2_tb/sha256_640_1/enable
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/data_i
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/s_m
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/s_hash
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/s_hash_out
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/digest_o
add wave -noupdate -divider {Hashing 1}
add wave -noupdate /mine_2_tb/sha256_640_1/sha256_hashing_1/start
add wave -noupdate /mine_2_tb/sha256_640_1/sha256_hashing_1/done
add wave -noupdate /mine_2_tb/sha256_640_1/sha256_hashing_1/s_st
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_1/m
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_1/s_w
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_1/hash_i
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_1/hash_o
add wave -noupdate -divider {Hashing 2}
add wave -noupdate /mine_2_tb/sha256_640_1/sha256_hashing_2/start
add wave -noupdate /mine_2_tb/sha256_640_1/sha256_hashing_2/done
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_2/s_st
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_2/m
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_2/s_w
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_2/hash_i
add wave -noupdate -radix hexadecimal /mine_2_tb/sha256_640_1/sha256_hashing_2/hash_o
add wave -noupdate -divider {SHA 256}
add wave -noupdate /mine_2_tb/SHA256/start
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/data_i
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/s_m
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/s_hash_out
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/digest_o
add wave -noupdate -divider Hashing
add wave -noupdate /mine_2_tb/SHA256/sha256_hashing_instance/start
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/sha256_hashing_instance/done
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/sha256_hashing_instance/m
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/sha256_hashing_instance/s_st
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/sha256_hashing_instance/s_w
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/sha256_hashing_instance/hash_i
add wave -noupdate -radix hexadecimal /mine_2_tb/SHA256/sha256_hashing_instance/hash_o
add wave -noupdate -divider Result
add wave -noupdate -radix hexadecimal /mine_2_tb/digest_o
add wave -noupdate -radix hexadecimal /mine_2_tb/digest_o_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {117429 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 119
configure wave -valuecolwidth 84
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
WaveRestoreZoom {102516 ps} {310394 ps}
