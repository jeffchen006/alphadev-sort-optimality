# n=5 model=out iset=I1 prefix14_class=12964
mov S1, P3
cmp P0, P1
cmovl S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P2, P3
mov S0, P1
cmovg S1, P2
cmovge P2, P3
cmp P2, P1
cmovg P1, P2
cmovge P2, S0
mov S0, P0
cmp S1, S0
