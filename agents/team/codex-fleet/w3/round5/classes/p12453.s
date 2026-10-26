# n=5 model=out iset=I1 prefix14_class=12453
cmp P1, P0
cmovl S0, P1
mov S1, P3
cmovl P1, P0
cmovl P0, S0
cmp S1, P2
cmovge P3, P2
cmovl S1, P2
cmp P0, P3
cmovle S2, P3
cmovg S2, P0
cmovl P3, P0
cmp S1, P1
cmovg P3, S1
