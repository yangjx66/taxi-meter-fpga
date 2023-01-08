///////////////////////////////////////////////////////////////////////
// Module Name   : pulse_count
// Description   : 轮速脉冲计数器
////////////////////////////////////////////////////////////////////////

module pulse_count (
    input   wire    sys_clk,        //时钟信号输入
    input   wire    pulse_port,     //脉冲信号输入
    input   wire    sys_rst_n,      //复位信号输入
    input   wire    stat_change,    //状态切换信号输入

    output  reg     [19:0]  pulse_num            //计数值输出
);

reg [1:0]   drive_stat;     //行驶状态：0表示未开始计价，1表示接单途中等待，2表示接单途中行驶

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) //复位
        pulse_num <= 20'd0;
    else if (pulse_port == 1'b0) //下降沿脉冲输入
        pulse_num <= pulse_num + 20'd1;
    else
        pulse_num <= pulse_num;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0)
        drive_stat <= 2'd0;
    else if (stat_change == 1'b0) begin //按键按下时
        case(drive_stat)
            2'b00    : drive_stat <= 2'b10; 		// drive_stat等于0时，按下按键，说明开始计价，跳转到驾驶状态2
            2'b01    : drive_stat <= 2'b10; 		// drive_stat等于1时，按下按键，说明要从等待状态跳转到驾驶状态2
            2'b10    : drive_stat <= 2'b01; 		// drive_stat等于2时，按下按键，说明需要进入等待状态1
            default  : drive_stat <= 2'b00; 		// If sel is anything else, out is always 0
        endcase
    end
    else
        drive_stat <= drive_stat;
end

endmodule
