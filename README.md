# IIT Roorkee CSE
# CSN-221
# Memory Project

### This project implements set-associative cache using write-back policy. 
### It is written in Verilog and implements a least recently used replacement policy.

## Specifications:
- number of ways is variable
- number of sets is variable
- 25 bit address

## Cases it can handle:
1. write-hit 
2. write-miss 
3. read-hit 
4. read-miss

## Instruction format:
- 1st bit specifies read(0)/write(1)
- rest 24 bits specify memory address

## Sample instructions:
- 0000000000000001110111110 (read)
- 1000000000001111110010001 (write)

## Graph:
![WhatsApp Image 2022-11-13 at 13 29 24](https://user-images.githubusercontent.com/98893455/201518436-ab9d8700-7bc4-4289-8d16-1f2d6c31f87f.jpg)

Configurations for the above Bar Chart:

- Configuration 1:  32kB   64B   8 Ways
- Configuration 2:  32kb   64B   Direct Mapped
- Configuration 3:  16kB   64B   16 Ways

## Group members: 
- Neha Gujar 21114039
- Manan Garg 21114056 
- Manashree Kalode 21114057 
- Nishita Singh 21114068
- Raiwat Bapat 21114078 
- Sanidhya Bhatia 21114090
