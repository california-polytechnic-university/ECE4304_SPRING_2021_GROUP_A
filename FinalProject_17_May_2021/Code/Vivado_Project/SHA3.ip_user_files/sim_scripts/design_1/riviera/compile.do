vlib work
vlib riviera

vlib riviera/axi_lite_ipif_v3_0_4
vlib riviera/lib_pkg_v1_0_2
vlib riviera/lib_srl_fifo_v1_0_2
vlib riviera/lib_cdc_v1_0_2
vlib riviera/axi_uartlite_v2_0_23
vlib riviera/xil_defaultlib
vlib riviera/microblaze_v11_0_1
vlib riviera/lmb_v10_v3_0_9
vlib riviera/lmb_bram_if_cntlr_v4_0_16
vlib riviera/blk_mem_gen_v8_4_3
vlib riviera/mdm_v3_2_16
vlib riviera/proc_sys_reset_v5_0_13
vlib riviera/generic_baseblocks_v2_1_0
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_register_slice_v2_1_19
vlib riviera/fifo_generator_v13_2_4
vlib riviera/axi_data_fifo_v2_1_18
vlib riviera/axi_crossbar_v2_1_20
vlib riviera/axi_timer_v2_0_21

vmap axi_lite_ipif_v3_0_4 riviera/axi_lite_ipif_v3_0_4
vmap lib_pkg_v1_0_2 riviera/lib_pkg_v1_0_2
vmap lib_srl_fifo_v1_0_2 riviera/lib_srl_fifo_v1_0_2
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap axi_uartlite_v2_0_23 riviera/axi_uartlite_v2_0_23
vmap xil_defaultlib riviera/xil_defaultlib
vmap microblaze_v11_0_1 riviera/microblaze_v11_0_1
vmap lmb_v10_v3_0_9 riviera/lmb_v10_v3_0_9
vmap lmb_bram_if_cntlr_v4_0_16 riviera/lmb_bram_if_cntlr_v4_0_16
vmap blk_mem_gen_v8_4_3 riviera/blk_mem_gen_v8_4_3
vmap mdm_v3_2_16 riviera/mdm_v3_2_16
vmap proc_sys_reset_v5_0_13 riviera/proc_sys_reset_v5_0_13
vmap generic_baseblocks_v2_1_0 riviera/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_19 riviera/axi_register_slice_v2_1_19
vmap fifo_generator_v13_2_4 riviera/fifo_generator_v13_2_4
vmap axi_data_fifo_v2_1_18 riviera/axi_data_fifo_v2_1_18
vmap axi_crossbar_v2_1_20 riviera/axi_crossbar_v2_1_20
vmap axi_timer_v2_0_21 riviera/axi_timer_v2_0_21

vcom -work axi_lite_ipif_v3_0_4 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_pkg_v1_0_2 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vcom -work lib_srl_fifo_v1_0_2 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work axi_uartlite_v2_0_23 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/0315/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_axi_uartlite_0_1/sim/design_1_axi_uartlite_0_1.vhd" \

vcom -work microblaze_v11_0_1 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/f8c3/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_microblaze_0_4/sim/design_1_microblaze_0_4.vhd" \

vcom -work lmb_v10_v3_0_9 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/78eb/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_dlmb_v10_3/sim/design_1_dlmb_v10_3.vhd" \
"../../../bd/design_1/ip/design_1_ilmb_v10_3/sim/design_1_ilmb_v10_3.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_16 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/6335/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_dlmb_bram_if_cntlr_3/sim/design_1_dlmb_bram_if_cntlr_3.vhd" \
"../../../bd/design_1/ip/design_1_ilmb_bram_if_cntlr_3/sim/design_1_ilmb_bram_if_cntlr_3.vhd" \

vlog -work blk_mem_gen_v8_4_3  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/c001/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../bd/design_1/ip/design_1_lmb_bram_3/sim/design_1_lmb_bram_3.v" \

vcom -work mdm_v3_2_16 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/550e/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_mdm_1_0/sim/design_1_mdm_1_0.vhd" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_rst_sys_clk_100M_0/sim/design_1_rst_sys_clk_100M_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_19  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_4  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_4 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_4  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_18  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_20  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" \
"../../../bd/design_1/ip/design_1_xbar_3/sim/design_1_xbar_3.v" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ipshared/085c/src/B2BCD_Nbit.vhd" \
"../../../bd/design_1/ipshared/085c/src/Counter.vhd" \
"../../../bd/design_1/ipshared/085c/src/Decoder_7seg.vhd" \
"../../../bd/design_1/ipshared/085c/src/Keccak_Permutation.vhd" \
"../../../bd/design_1/ipshared/085c/src/Message_Prepare.vhd" \
"../../../bd/design_1/ipshared/085c/src/Mux_Nx1.vhd" \
"../../../bd/design_1/ipshared/085c/src/SHA3.vhd" \
"../../../bd/design_1/ipshared/085c/src/SHA3_System_Top.vhd" \
"../../../bd/design_1/ipshared/085c/hdl/SHA_3_v2_0_S00_AXI.vhd" \
"../../../bd/design_1/ipshared/085c/src/Top_7seg.vhd" \
"../../../bd/design_1/ipshared/085c/src/VGA_Top.vhd" \
"../../../bd/design_1/ipshared/085c/src/VGA_VHDL.vhd" \
"../../../bd/design_1/ipshared/SHA_3_1.0/src/get_sprite_224.vhd" \
"../../../bd/design_1/ipshared/SHA_3_1.0/src/get_sprite_256.vhd" \
"../../../bd/design_1/ipshared/SHA_3_1.0/src/get_sprite_384.vhd" \
"../../../bd/design_1/ipshared/SHA_3_1.0/src/get_sprite_512.vhd" \
"../../../bd/design_1/ipshared/SHA_3_1.0/src/vga_initials.vhd" \
"../../../bd/design_1/ipshared/085c/hdl/SHA_3_v2_0.vhd" \
"../../../bd/design_1/ip/design_1_SHA_3_0_2/sim/design_1_SHA_3_0_2.vhd" \

vcom -work axi_timer_v2_0_21 -93 \
"../../../../SHA3.srcs/sources_1/bd/design_1/ipshared/a788/hdl/axi_timer_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_axi_timer_0_0/sim/design_1_axi_timer_0_0.vhd" \
"../../../bd/design_1/sim/design_1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

