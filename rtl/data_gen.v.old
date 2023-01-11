////////////////////////////////////////////////////////////////////////
// Module Name   : data_gen
// Description   : 生成数码管显示数据
////////////////////////////////////////////////////////////////////////

`timescale  1ns/1ns

module  data_gen
#(
    parameter   CNT_MAX = 23'd4999_999, //100ms计数值
    parameter   DATA_MAX= 20'd999_999   //显示的最大值
)
(
    input   wire            sys_clk     ,   //系统时钟，频率50MHz
    input   wire            sys_rst_n   ,   //复位信号，低电平有效

    output  reg     [19:0]  data        ,   //数码管要显示的值
    output  wire    [5:0]   point       ,   //小数点显示,高电平有效
    output  reg             seg_en      ,   //数码管使能信号，高电平有效
    output  wire            sign            //符号位，高电平显示负号
);

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//

//reg   define
reg     [22:0]  cnt_100ms   ;   //100ms计数器
reg             cnt_flag    ;   //100ms标志信号

//********************************************************************//
//***************************** Main Code ****************************//
//********************************************************************//

//不显示小数点以及负数
assign  point   =   6'b000_000;
assign  sign    =   1'b0;

//cnt_100ms:用50MHz时钟从0到4999_999计数即为100ms
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_100ms   <=  23'd0;
    else    if(cnt_100ms == CNT_MAX)
        cnt_100ms   <=  23'd0;
    else
        cnt_100ms   <=  cnt_100ms + 1'b1;

//cnt_flag:每100ms产生一个标志信号
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_flag    <=  1'b0;
    else    if(cnt_100ms == CNT_MAX - 1'b1)
        cnt_flag    <=  1'b1;
    else
        cnt_flag    <=  1'b0;

//数码管显示的数据:0-999_999
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        data    <=  20'd0;
    else    if((data == DATA_MAX) && (cnt_flag == 1'b1))
        data    <=  20'd0;
    else    if(cnt_flag == 1'b1)
        data    <=  data + 1'b1;
    else
        data    <=  data;

//数码管使能信号给高即可
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        seg_en  <=  1'b0;
    else
        seg_en  <=  1'b1;

endmodule