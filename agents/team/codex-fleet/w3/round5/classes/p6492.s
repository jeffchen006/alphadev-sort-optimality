# n=5 model=out iset=I1 prefix14_class=6492
mov S0, P0
cmp P1, P0
cmovl P0, P1
cmovg S0, P1
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmovge S1, P3
cmp S1, S0
cmovl P1, S0
cmovle S0, S1
mov P3, S0
cmovl S1, P1
cmp P0, P2
