# n=5 model=out iset=I1 prefix14_class=13681
cmp P0, P2
cmovge S1, P2
cmovl S1, P0
cmovl P0, P2
mov S2, P3
cmp P1, P3
cmovle P3, P1
cmovg S2, P1
cmp P0, S2
cmovge P2, S2
mov S0, S1
cmovg S2, P0
cmovg P0, P2
mov P1, P0
