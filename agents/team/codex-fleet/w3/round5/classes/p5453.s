# n=5 model=out iset=I1 prefix14_class=5453
cmp P1, P0
mov S1, P1
cmovl P1, P0
cmovg S1, P0
mov S0, S1
cmp P2, P3
mov S2, P1
cmovge P0, P3
cmovge P3, P2
cmovg P2, P0
cmp P2, S1
cmovl S0, P2
cmovl P2, S1
cmp P1, P3
