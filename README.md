# taximeter

## **出租车计价器代做项目**

> * 软件：Quartus 13.1
> * 语言：Verilog
> * 芯片型号：Altera Cyclone IVE EP4CE10F17C8
> * 仿真软件：Modelsim

**目标和要求系统必须具有如下基础功能:**
* 1、当行程小于基本里程时，显示起步价，基本里程设3公里，起步价设8元
* 2、当行程大于基本里程时，每多行一公里，在起步价上加2元;不足一公里按一公里收费
* 3、当出租车等待时，由司机按下等候键，每等待一分钟加1元，不足一分钟的按一分钟计算
* 4、此处用脉冲信号模拟轮胎的转数，设每计一个脉冲汽车前进100米
* 5、熟悉硬件描述语言编程，了解实际设计中的优化方案课题最终成果形式: 基于FPGA的出租车计费器的设计与实现系统工程文件、软件系统工程文件，功能实现