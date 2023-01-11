`timescale  1ns/1ns

module tb_data_gen();

    reg            sys_clk     ;   //时钟信号输入
    reg            sys_rst_n   ;   //复位信号输入
    reg            pulse_port  ;   //脉冲信号输入
    reg            stat_port   ;   //状态切换信号输入
    
   wire    [5:0]   point       ;  //小数点显示,高电平有效
   
   wire     [19:0]  price       ;   //价格
   wire             seg_en      ;   //数码管使能信号，高电平有效
   
   wire            sign        ;   //符号位，高电平显示负号
   wire            stat_led    ;   //指示状态的led
   
   wire             dist_led  ;      //里程每增加100米，led取反一次

initial
    begin
        sys_clk     =   1'b1;
        sys_rst_n   <=  1'b0;
        pulse_port <= 1'b1;
        stat_port <= 1'b1;
        #100
        sys_rst_n   <=  1'b1;
        #100
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        # 999999
        pulse_port <= 1'b1;
        # 999999
        pulse_port <= 1'b0;
        #10000
        stat_port <= 1'b0;
        #999999
        stat_port <= 1'b1;
    end

always  #10 sys_clk <=  ~sys_clk;

defparam  data_gen_inst.CNT_MAX    =   49;
defparam  data_gen_inst.Freq       =   4999;

data_gen data_gen_inst
(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .pulse_port(pulse_port),
    .stat_port(stat_port),

    .point(point),
    .price(price),
    .seg_en(seg_en),
    .sign(sign),
    .stat_led(stat_led),
    .dist_led(dist_led)
);

endmodule
