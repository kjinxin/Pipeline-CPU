onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/clk
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/PC
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/WB_WBData
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/WB_MemData
add wave -noupdate -divider <NULL>
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/ALU_out
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/Shift_out
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/RegWrite
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/Mem_WriteEn
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/WB_WBType
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/MEM_WBType
add wave -noupdate -divider <NULL>
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/BranchValid
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/C_A
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/C_B
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/EX_MEM_Flush
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/EX_MEM_Stall
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/ExtendI
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/ID_EX_Flush
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/ID_EX_Stall
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/IF_ID_Flush
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/IF_ID_RtRead
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/IF_ID_Stall
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/MEM_WB_Flush
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/MEM_WB_Stall
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/PCSrc
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/ReadReg1
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/ReadReg2
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/ShiftAmount
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/WriteReg
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/fwd_MemReadID_EX
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/fwd_RdEX_MEM
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/fwd_RdMEM_WB
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/fwd_RegWriteEX_MEM
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/fwd_RegWriteMEM_WB
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/fwd_RsID_EX
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/fwd_RsIF_ID
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/fwd_RtID_EX
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/fwd_RtIF_ID
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/fwd_RdID_EX
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/ID_Jump
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/MEM_Branch_addr
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/MEM_Addr
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/MEM_DataOut
add wave -noupdate -format Literal /PipelineMIPS_vlg_tst/MEM_Op
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/MEM_WB_Flush
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/MEM_WB_Stall
add wave -noupdate -format Literal -radix hexadecimal /PipelineMIPS_vlg_tst/MEM_data_in
add wave -noupdate -format Logic /PipelineMIPS_vlg_tst/ID_MemWrite
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {124316 ps} 0}
configure wave -namecolwidth 240
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {261966 ps}
