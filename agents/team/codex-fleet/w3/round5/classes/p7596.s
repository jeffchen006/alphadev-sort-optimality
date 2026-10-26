# n=5 model=out iset=I1 prefix14_class=7596
mov S0, P3
cmp P3, P2
cmovg S0, P2
cmovl P3, P2
cmp P1, P0
mov S2, P1
cmovge P1, P0
mov S1, S0
cmovle S2, P0
cmp S1, P1
cmovl S0, P1
cmovg S1, P1
cmp S2, P3
cmovl P1, S0
