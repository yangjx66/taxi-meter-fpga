# TaxiMeter

## **基于FPGA的出租车计价器系统**
> * 作者:       YangJinxi
> * 创建日期:   2023/1/8
> * 软件环境:   Quartus 13.1
> * 仿真环境:   Modelsim
> * 编程语言:   Verilog HDL
> * 芯片型号:   Altera Cyclone IVE EP4CE10F17C8

**系统具有如下基础功能:**
* 1、当行程小于基本里程时，显示起步价，基本里程设3公里，起步价设8元
* 2、当行程大于基本里程时，每多行一公里，在起步价上加2元;不足一公里按一公里收费
* 3、当出租车等待时，由司机按下等候键，每等待一分钟加1元，不足一分钟的按一分钟计算
* 4、此处用脉冲信号模拟轮胎的转数，设每计一个脉冲汽车前进100米
* 5、基于FPGA的出租车计费器的设计与实现系统工程文件、软件系统工程文件，功能实现
