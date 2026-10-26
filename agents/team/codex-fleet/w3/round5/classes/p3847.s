# n=5 model=out iset=I1 prefix14_class=3847
mov S0, P3
cmp S0, P0
cmovge P3, P0
cmovge P0, S0
cmp P2, P1
cmovg S0, P2
cmovle S0, P1
cmovl P1, P2
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
cmp P0, S0
mov P1, S0
