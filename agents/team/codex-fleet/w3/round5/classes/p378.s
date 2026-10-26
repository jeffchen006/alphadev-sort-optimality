# n=5 model=out iset=I1 prefix14_class=378
mov S0, P2
cmp S0, P0
mov S1, P1
cmovg S0, P0
cmovl P2, P0
cmp P1, P3
cmovge P1, P3
cmovl S1, P3
mov S2, S0
cmp P1, S2
cmovle S2, P1
cmovl P1, S0
mov P0, S1
cmp P2, S1
