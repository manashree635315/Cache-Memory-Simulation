# IIT Roorkee CSE
# CSN-221
# Memory Project

### This project implements set-associative cache(functional model only) 
### It is written in Verilog and uses Least Recently Used replacement policy

## Specifications:
- currently the hexadecimal to binary instruction encoding function is written only for hex instructions of length 6 or 7
- number of ways is variable which is given as input
- number of bits needed for set number and block offset are variable which is given as input
- total number of queries are also taken as input
- 25 bit address

## Steps to run:
1. In instructions.txt, paste the memory trace in hexadecimal format
2. Run query.exe
3. Set the parameters in finalcode.v and the name of file containing memory trace in binary format in line 34
(We have as of now added the binary traces for 4 traces available [here](http://www.cs.toronto.edu/~reid/csc150/02f/a2/traces.html) for quick demo)
4. Run finalcode.v!

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

Configurations for the above Bar Graph:
<pre>
      Cache Size        Set Size       No of ways
1:    32kB              64B            8
2:    32kB              64B            1 (Direct Mapped)
3:    16kB              64B            16
</pre>
## Group members: 
- Neha Gujar 21114039
- Manan Garg 21114056 
- Manashree Kalode 21114057 
- Nishita Singh 21114068
- Raiwat Bapat 21114078 
- Sanidhya Bhatia 21114090
