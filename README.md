# STM32F429I-Discovery BSP example (Button, LCD, TS, Gyro ...) #

This is just the BSP example for the STM32F429I-Discovery from the STM32CubeF4 (STM32Cube_FW_F4_V1.4.0/Projects/STM32F429I-Discovery/Examples/BSP) with a linux makefile.
You need [STM32CubeF4](http://www.st.com/web/catalog/tools/FM147/CL1794/SC961/SS1743/PF259243#), [stlink](https://github.com/texane/stlink), and gcc arm:
```
sudo add-apt-repository -y ppa:terry.guo/gcc-arm-embedded
sudo apt-get update
sudo apt-get -y install gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi openocd
```

Compile and flash the board:
```
make
make burn
```

Basic instructions to handle STM32F4 dev on linux can be found [here](https://github.com/theotime/STM32CubeF4_makefile_template).
