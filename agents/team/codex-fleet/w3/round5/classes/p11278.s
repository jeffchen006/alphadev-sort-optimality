# n=5 model=out iset=I1 prefix14_class=11278
mov S0, P2
cmp P0, P1
cmovg S1, P1
cmovle S1, P0
cmovl P0, P1
cmp P2, P3
cmovge P2, P3
cmovl S0, P3
cmp S0, P0
mov S2, S1
cmovle P1, P0
cmovl P0, S0
cmovle S0, P1
mov S0, P0
