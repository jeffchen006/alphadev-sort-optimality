# n=5 model=out iset=I1 prefix14_class=11966
mov S1, P0
cmp P3, S1
cmovl S1, P3
cmovg P0, P3
mov P3, P2
cmp P1, P2
cmovge P3, P1
cmovl P2, P1
mov S0, P0
cmp S1, P2
cmovg S2, P2
cmovg P2, S1
cmovg S1, S2
cmp P0, P3
