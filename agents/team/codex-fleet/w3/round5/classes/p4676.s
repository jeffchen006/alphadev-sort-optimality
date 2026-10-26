# n=5 model=out iset=I1 prefix14_class=4676
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
mov S2, P1
cmp P3, S2
cmovg S2, P3
cmovl P1, P3
mov P3, S2
cmp S2, P0
cmovl P3, P0
cmovg S2, P0
mov S0, S2
cmp P2, P1
