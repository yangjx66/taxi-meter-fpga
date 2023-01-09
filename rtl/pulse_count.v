///////////////////////////////////////////////////////////////////////
// Module Name   : pulse_count
// Description   : 轮速脉冲计数器
////////////////////////////////////////////////////////////////////////

module pulse_count 
#(
    parameter CNT_MAX = 20'd999_999     ,   //计数器计数最大值 限制20ms
    parameter Freq    = 26'd50_000_000      //时钟频率50MHz
)(
    input   wire            sys_clk     ,   //时钟信号输入
    input   wire            sys_rst_n   ,   //复位信号输入
    input   wire            pulse_port  ,   //脉冲信号输入
    input   wire            stat_port   ,   //状态切换信号输入

    output  reg     [19:0]  pulse_num       //计数值输出
); 

reg [1:0]   drive_stat  ;   //行驶状态：0表示未开始计价，1表示接单途中等待，2表示接单途中行驶

reg         pulse_flag  ;   //pulse_flag=1时表示接收到一次脉冲
reg         stat_flag   ;   //stat_flag=1时表示进行一次状态切换

reg [19:0]  cnt_20ms    ;   //脉冲滤波计数器
reg [19:0]  cnt_20ms1   ;   //状态切换滤波计数器

reg [19:0]  price       ;   //计价器显示的价格
reg [19:0]  km_num      ;   //公里数

reg [25:0]  wait_cnt    ;   //26bit，等待时的计数器，计满为1s
reg [19:0]  wait_min    ;   //等待的分钟数，不足一分钟按一分钟算
reg [5:0]   wait_sec    ;   //不足1min的部分
reg [19:0]  wait_price  ;   //等待时额外的费用

//****************************************************************************************************************
//等待按键按下之后，切换到等待状态，及drive_stat = 1，每等待一分钟，加一块钱，不足一分钟的按一分钟算
//wait_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) //异步复位
        wait_cnt <= 26'd0;
    else if (drive_stat == 2'd1) begin//等待状态 drive_stat = 1
        if (wait_cnt < Freq) 
            wait_cnt <= wait_cnt + 1'b1; //小于最大值的时候，自增1
        else
            wait_cnt <= 26'd0;//wait_cnt>=最大值的时候，归零
    end
    else if (drive_stat != 2'd1)
        wait_cnt <= 26'd0;
    else
        wait_cnt <= wait_cnt; //运行不到这里
end
//wait_sec
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0)
        wait_sec <= 1'b0;
    else if (wait_cnt >= Freq) begin
        if (wait_sec >= 6'd60) //计满一分钟
            wait_sec <= 6'd0; //清零
        else
            wait_sec <= wait_sec + 6'd1; //秒+1
    end
    else
        wait_sec <= wait_sec;
end
//wait_min
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0)
        wait_min <= 20'd0;
    else if (wait_sec == 6'd60)
        wait_min <= wait_min + 1'd1;
    else
        wait_min <= wait_min;
end
//****************************************************************************************************************
//这里是
//pulse_num<=30:price=8
//pulse_num> 30:price=8+2*((pulse_num-30)/10)
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0)
        price <= 20'd0;

    else begin
        if (km_num <= 20'd3) //公里数小于3时
            price <= 20'd8; //起步价8元
        else if (km_num > 20'd3) //大于3公里的时候
            //减去初始3km，判断是否有不足一公里的部分，有的话再加1km，然后乘以2，再加上起步价8块，再加等待时间的费用
            price <= ((km_num - 20'd3 + ((pulse_num == 20'd0) ? 20'd0 : 20'd1)) * 20'd2) + 20'd8 + wait_min + ((wait_sec == 6'd0) ? 20'd0 : 20'd1); 
        else
            price <= price;
    end
end

//****************************************************************************************************************
//控制
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) begin//复位
        pulse_num <= 20'd0;
        km_num <= 20'd0;
    end

    else if (pulse_flag == 1'b1) begin//pulse_flag 上升沿脉冲输入
        if (pulse_num == 20'd10) begin //等于10说明里程数增加了1公里
            km_num <= km_num + 20'd1; //公里数加1km
            pulse_num <= 20'd1; //满10，变一
        end

        else if (pulse_num < 20'd10) begin //脉冲计数值小于10的时候，让
            pulse_num <= pulse_num + 20'd1; //加100m
            km_num <= km_num;
        end
        else begin
            pulse_num <= pulse_num;
            km_num <= km_num;
        end
    end

    else begin
        pulse_num <= pulse_num;
        km_num <= km_num;
    end
end

//stat_flag = 1 也就是状态转换按键按下且消抖结束后拉高
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (sys_rst_n == 1'b0) begin
        drive_stat <= 2'd0; //默认是0状态，也就是等待开车
    end

    else if (stat_flag == 1'b1) begin //按键按下时
        case(drive_stat)
            2'd0    : drive_stat <= 2'd2; 		// drive_stat等于0时，按下按键，说明开始计价，跳转到驾驶状态2
            2'd1    : drive_stat <= 2'd2; 		// drive_stat等于1时，按下按键，说明要从等待状态跳转到驾驶状态2
            2'd2    : drive_stat <= 2'd1; 		// drive_stat等于2时，按下按键，说明需要进入等待状态1
            default  : drive_stat <= 2'd0; 		// If sel is anything else, out is always 0
        endcase
    end

    else begin
        drive_stat <= drive_stat;
    end
end

//****************************************************************************************************************
//状态切换按键滤波模块
//cnt_20ms1:如果时钟的上升沿检测到外部按键输入的值为低电平时，计数器开始计数
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 1'b0) begin
        cnt_20ms1 <= 20'b0;
        stat_flag <= 1'b0;
    end

    else if(stat_port == 1'b1) begin//松手为1
        cnt_20ms1 <= 20'b0;
        stat_flag <= 1'b0;
    end

    else if(cnt_20ms1 == CNT_MAX && stat_port == 1'b0) begin //按下为0
        cnt_20ms1 <= 20'd0;
        stat_flag <= 1'b1; //拉高一个时钟周期
    end

    else begin
        cnt_20ms1 <= cnt_20ms1 + 1'b1;
        stat_flag <= 1'b0;        
    end
end

//用于切换状态的按键
// always @(posedge sys_clk or negedge sys_rst_n) begin
//     if (sys_rst_n == 1'b0)
//         stat_flag <= 1'b1;

//     else if (cnt_20ms1 == CNT_MAX)
//         stat_flag <= 1'b0; //计数值计满之后，拉低

//     else
//         stat_flag <= stat_flag;
// end
//****************************************************************************************************************
//脉冲按键滤波模块
//cnt_20ms:如果时钟的上升沿检测到外部按键输入的值为低电平时，计数器开始计数
//pulse_flag:当计数满20ms后产生按键有效标志位
//且 pulse_flag 在999_999时拉高,维持一个时钟的高电平
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 1'b0) begin
        cnt_20ms <= 20'b0;
        pulse_flag <= 1'b0;
    end

    else if(pulse_port == 1'b1) begin//松手为1
        cnt_20ms <= 20'b0;
        pulse_flag <= 1'b0;
    end

    else if(cnt_20ms == CNT_MAX && pulse_port == 1'b0) begin//按下为0
        cnt_20ms <= 20'd0;
        pulse_flag <= 1'b1; //标志位拉高一个时钟周期
    end

    else begin
        cnt_20ms <= cnt_20ms + 1'b1;
        pulse_flag <= 1'b0;
    end
end


// always@(posedge sys_clk or negedge sys_rst_n) begin
//     if(sys_rst_n == 1'b0)
//         pulse_flag <= 1'b0; //pulse_flag 默认高电平

//     else if(cnt_20ms == CNT_MAX) //消去抖动
//         pulse_flag <= 1'b1; //pulse_flag拉高一个时钟周期

//     else
//         pulse_flag <= 1'b0;
// end
//****************************************************************************************************************

endmodule
