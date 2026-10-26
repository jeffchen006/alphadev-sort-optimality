# n=5 model=out iset=I1 prefix14_class=1007
cmp P0, P3
mov S0, P3
cmovl P3, P0
mov S1, P2
cmovg S0, P0
cmp S1, P1
cmovg S1, P1
mov P0, S0
cmovge P1, P2
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
mov S2, P3
cmp S1, P3
