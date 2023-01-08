///////////////////////////////////////////////////////////////////////
// Module Name   : pulse_count
// Description   : 轮速脉冲计数器
////////////////////////////////////////////////////////////////////////

module pulse_count 
#(
    parameter CNT_MAX = 20'd999_999 //计数器计数最大值 限制20ms
)(
    input   wire    sys_clk,        //时钟信号输入
    input   wire    pulse_port,     //脉冲信号输入
    input   wire    sys_rst_n,      //复位信号输入
    input   wire    stat_change,    //状态切换信号输入

    output  reg     [19:0]  pulse_num            //计数值输出
); 

reg [1:0]   drive_stat;     //行驶状态：0表示未开始计价，1表示接单途中等待，2表示接单途中行驶
reg         pulse_flag;     //pulse_flag=1时表示接收到一次脉冲
reg [19:0]  cnt_20ms ;      //计数器

//不与时钟信号同步，为了更加精准的监测 pulse_flag 信号变化
//但是需要与异步复位信号同步
//pulse_flag 上升沿信号触发，是按键松手信号
always @(posedge pulse_flag or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) //复位
        pulse_num <= 20'd0;
    else if (pulse_flag == 1'b1) //pulse_flag 上升沿脉冲输入
        pulse_num <= pulse_num + 20'd1;
    else
        pulse_num <= pulse_num;
end

//pulse_flag:当计数满20ms后产生按键有效标志位
//且 pulse_flag 在999_999时拉高,维持一个时钟的高电平
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 1'b0)
        pulse_flag <= 1'b1; //pulse_flag 默认高电平
    else if(cnt_20ms == CNT_MAX)
        pulse_flag <= 1'b0; //按键按下且经过消抖后，pulse_flag拉低，产生一个上升沿信号
    else
        pulse_flag <= 1'b1;
end

// always @(posedge sys_clk or negedge sys_rst_n) begin
//     if (sys_rst_n == 1'b0)
//         drive_stat <= 2'd0;
//     else if (stat_change == 1'b0) begin //按键按下时
//         case(drive_stat)
//             2'b00    : drive_stat <= 2'b10; 		// drive_stat等于0时，按下按键，说明开始计价，跳转到驾驶状态2
//             2'b01    : drive_stat <= 2'b10; 		// drive_stat等于1时，按下按键，说明要从等待状态跳转到驾驶状态2
//             2'b10    : drive_stat <= 2'b01; 		// drive_stat等于2时，按下按键，说明需要进入等待状态1
//             default  : drive_stat <= 2'b00; 		// If sel is anything else, out is always 0
//         endcase
//     end
//     else
//         drive_stat <= drive_stat;
// end

//按键滤波模块
//cnt_20ms:如果时钟的上升沿检测到外部按键输入的值为低电平时，计数器开始计数
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 1'b0)
        cnt_20ms <= 20'b0;
    else    if(pulse_port == 1'b1) //松手为1
        cnt_20ms <= 20'b0;
    else    if(cnt_20ms == CNT_MAX && pulse_port == 1'b0) //按下为0
        cnt_20ms <= cnt_20ms;
    else
        cnt_20ms <= cnt_20ms + 1'b1;
end

endmodule
