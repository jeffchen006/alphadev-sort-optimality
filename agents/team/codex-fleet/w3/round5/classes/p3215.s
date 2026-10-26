# n=5 model=out iset=I1 prefix14_class=3215
mov S0, P2
mov S2, P1
cmp P3, S0
cmovl P2, P3
cmovg S0, P3
cmp P0, S2
cmovl P1, P0
cmovge S2, P0
mov P0, P2
cmp P1, P2
cmovg P2, P1
cmovge P1, P0
cmp S2, S0
cmovg P1, S0
