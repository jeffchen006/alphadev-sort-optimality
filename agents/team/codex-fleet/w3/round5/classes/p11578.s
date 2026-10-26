# n=5 model=out iset=I1 prefix14_class=11578
mov S2, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovg S1, P1
cmp P2, P3
cmovle P3, P2
mov S0, P3
cmovle P2, S2
cmp S1, S0
cmovle S0, S1
cmovl S1, P3
cmp P2, P0
cmovle S2, P0
