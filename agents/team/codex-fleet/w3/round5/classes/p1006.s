# n=5 model=out iset=I1 prefix14_class=1006
cmp P0, P3
mov S0, P3
cmovg S0, P0
cmovl P3, P0
mov S2, P1
cmp P1, P2
cmovge S2, P2
mov P0, S0
cmovge P2, P1
cmp P2, S0
cmovge S0, P2
cmovg P2, P0
mov S1, P3
cmp S2, S1
