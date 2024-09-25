`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    input  wire [23:0]  sw,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst, // 当前时钟周期是否有指令写�? (对单周期CPU，可在复位后恒置1)
    output wire [31:0]  debug_wb_pc,        // 当前写回的指令的PC (若wb_have_inst=0，此项可为任意�??)
    output              debug_wb_ena,       // 指令写回时，寄存器堆的写使能 (若wb_have_inst=0，此项可为任意�??)
    output wire [ 4:0]  debug_wb_reg,       // 指令写回时，写入的寄存器�? (若wb_ena或wb_have_inst=0，此项可为任意�??)
    output wire [31:0]  debug_wb_value      // 指令写回时，写入寄存器的�? (若wb_ena或wb_have_inst=0，此项可为任意�??)
`endif
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;
   

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
    wire [13:0] inst_addr;
`endif
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_we;
    wire [31:0] Bus_wdata;
    
    wire [2:0] load_op;
    wire [1:0] store_op;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         we_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals
    // TODO: �ڴ˶���������������I/O�ӿڵ�·ģ��������ź�
    // Interface between bridge and 7-seg digital LEDs
    wire         rst_bridge2dig;
    wire         clk_bridge2dig;
    wire [31:0]  addr_bridge2dig;
    wire         we_bridge2dig;
    wire [31:0]  wdata_bridge2dig;

    // Interface between bridge and LEDs
    wire         rst_bridge2led;
    wire         clk_bridge2led;
    wire [31:0]  addr_bridge2led;
    wire         we_bridge2led;
    wire [31:0]  wdata_bridge2led;

    // Interface between bridge and switches
    wire         rst_bridge2sw;
    wire         clk_bridge2sw;
    wire [31:0]  addr_bridge2sw;
    wire [31:0]  rdata_sw2bridge;

    // Interface between bridge and buttons
    wire         rst_bridge2btn;
    wire         clk_bridge2btn;
    wire [31:0]  addr_bridge2btn;
    wire [31:0]  rdata_btn2bridge;
    

    
`ifdef RUN_TRACE
    // Trace����ʱ��ֱ��ʹ���ⲿ����ʱ��
    assign cpu_clk = fpga_clk;
`else
    // �°�ʱ��ʹ��PLL��Ƶ���ʱ��
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_we             (Bus_we),
        .Bus_wdata          (Bus_wdata),
        
        .load_op            (load_op),
        .store_op           (store_op)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    
    IROM Mem_IROM (
        .a          (inst_addr),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .we_from_cpu        (Bus_we),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .we_to_dram         (we_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to 7-seg digital LEDs
        .rst_to_dig         (rst_bridge2dig),
        .clk_to_dig         (clk_bridge2dig),
        .addr_to_dig        (addr_bridge2dig),
        .we_to_dig          (we_bridge2dig),
        .wdata_to_dig       (wdata_bridge2dig),
    
        // Interface to LEDs
        .rst_to_led         (rst_bridge2led),
        .clk_to_led         (clk_bridge2led),
        .addr_to_led        (addr_bridge2led),
        .we_to_led          (we_bridge2led),
        .wdata_to_led       (wdata_bridge2led),

        // Interface to switches
        .rst_to_sw          (rst_bridge2sw),
        .clk_to_sw          (clk_bridge2sw),
        .addr_to_sw         (addr_bridge2sw),
        .rdata_from_sw      (rdata_sw2bridge),

        // Interface to buttons
        .rst_to_btn         (rst_bridge2btn),
        .clk_to_btn         (clk_bridge2btn),
        .addr_to_btn        (addr_bridge2btn),
        .rdata_from_btn     (rdata_btn2bridge)
    );

//    DRAM Mem_DRAM (
//        .clk        (clk_bridge2dram),
//        .a          (addr_bridge2dram[15:2]),
//        .spo        (rdata_dram2bridge),
//        .we         (we_bridge2dram),
//        .d          (wdata_bridge2dram)
//    );
    
    mem U_mem(
        .clk        (clk_bridge2dram),
        .adr        (addr_bridge2dram),
        .wdin       (wdata_bridge2dram),
        .we         (we_bridge2dram),
        .load_op    (load_op),
        .store_op   (store_op),
        .rdo        (rdata_dram2bridge)
    );
    
    
//    DRAM Mem_DRAM (
//        .addra  (addr_bridge2dram[15:2]),
//        .clka   (clk_bridge2dram),
//        .dina   (wdata_bridge2dram),
//        .wea    (we_bridge2dram),
//        .douta  (rdata_dram2bridge)
//    );
    // TODO: �ڴ�ʵ�����������I/O�ӿڵ�·ģ��
    //    
    io_dig U_dig (
        .clk    (clk_bridge2dig),
        .rst    (rst_bridge2dig),
        .addr   (addr_bridge2dig),
        .we     (we_bridge2dig),
        .wdata  (wdata_bridge2dig),
        .led_en (dig_en),
        .DN_A   (DN_A),
        .DN_B   (DN_B),
        .DN_C   (DN_C),
        .DN_D   (DN_D),
        .DN_E   (DN_E),
        .DN_F   (DN_F),
        .DN_G   (DN_G),
        .DN_DP  (DN_DP)
    );
    
    io_led U_io_led (
        .clk    (clk_bridge2led),
        .rst    (rst_bridge2led),
        .addr   (addr_bridge2led),
        .we     (we_bridge2led),
        .wdata  (wdata_bridge2dig),
        .led    (led)
    );
    
    io_switch U_io_switch (
        .clk    (clk_bridge2sw),
        .rst    (rst_bridge2sw),
        .addr   (addr_bridge2sw),
        .switch (sw),
        .data_switch2cpu    (rdata_sw2bridge)
    );
    
    io_button U_io_button (
        .rst       (rst_bridge2btn),
        .clk       (clk_bridge2btn),
        .addr      (addr_bridge2btn),
        .button      (button),
        .data_btn2cpu     (rdata_btn2bridge)
    );

endmodule
