# n=3 R=4 iset=I1 source=AlphaDev sort_functions_test.cc Sort3AlphaDev, loads/stores removed; r8d=P0 eax=P1 ecx=P2 edx=S0; outputs out0=P0 out1=P2 out2=P1
cmp P2, P1
mov S0, P1
cmovl S0, P2
cmovg P1, P2
cmp P1, P0
mov P2, P0
cmovl P2, P1
cmovle P1, P0
cmp S0, P2
cmovle P0, S0
cmovg P2, S0
