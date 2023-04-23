transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+L:/ECE111/Final_ECE111/bitcoin_hash {L:/ECE111/Final_ECE111/bitcoin_hash/simplified_sha256.sv}
vlog -sv -work work +incdir+L:/ECE111/Final_ECE111/bitcoin_hash {L:/ECE111/Final_ECE111/bitcoin_hash/bitcoin_hash.sv}

