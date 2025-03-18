#! /usr/bin/python3

import os
import sys
import random

os.getcwd ()
os.system('mkdir -p vec')
file_o_s = './vec/o_s.vec'
file_o_c = './vec/o_c.vec'
file_i_a = './vec/i_a/vec'
file_i_b = './vec/i_b/vec'
file_i_c = './vec/i_c.vec'

fh_o_s = open(file_o_s, 'w')
fh_o_c = open(file_o_c, 'w')
fh_i_a = open(file_i_a, 'w')
fh_i_b = open(file_i_b, 'w')
fh_i_c = open(file_i_c. 'w')

simNum   = 20
bitWidth = 32

for n in range(simNum):
    intMIN, intMAX = 0, pow(2,bitWidth)-1
    intA           = random.randint(intMIN, intMAX)
    intB           = random.randint(intMIN, intMAX)
    intC           = random.randint(intMIN, 1)
    intSUM         = intA + intB + intC
    binA           = bin(intA)[2:].rjust(bitWidth, '0')
    binB           = bin(intB)[2:].rjust(bitWidth, '0')
    binC           = bin(intC)[2:].rjust(1, '0')
    binSUM         = bin(intSUM)[2:].rjust(bitWidth+1, '0')
    print('----------------------------------------')
    print('Iteration: %s'%(n))
    print('----------------------------------------')
    print('A   : %33s'%(binA))
    print('B   : %33s'%(binB))
    print('C   : %33s'%(binC))
    print('SUM : %33s'%(binSUM))
    print('----------------------------------------')
    fh_o_s.write(binSUM[1:bitWidth+1] + '\n')
    fh_o_c.write(binSUM[0] + '\n')
    fh_i_a.write(binA + '\n')
    fh_i_b.write(binB + '\n')
    fh_i_c.write(binC + '\n')

fh_o_s.close()
fh_o_c.close()
fh_i_a.close()
fh_i_b.close()
fh_i_c.close()
