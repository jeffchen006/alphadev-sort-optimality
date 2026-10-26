# n=5 model=out iset=I1 prefix14_class=9617
mov S2, P2
cmp S2, P1
cmovge S2, P1
mov S0, P0
cmovg P1, P2
cmp S0, P3
cmovl P0, P3
cmovg S0, P3
cmp P0, P1
mov S1, P0
cmovge S1, P1
cmovg P1, P0
cmp S0, S2
cmovg P3, S2
