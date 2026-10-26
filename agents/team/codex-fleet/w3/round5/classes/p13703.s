# n=5 model=out iset=I1 prefix14_class=13703
mov S2, P2
cmp P2, P1
cmovge S2, P1
cmovl P2, P1
mov S0, S2
cmp P0, P3
cmovg S1, P3
cmovge P3, P0
cmovg P0, S1
cmp P0, S2
cmovl S0, P0
cmovge S2, P0
cmp P2, P3
mov S0, P3
