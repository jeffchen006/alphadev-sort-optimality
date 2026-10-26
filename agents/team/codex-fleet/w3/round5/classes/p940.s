# n=5 model=out iset=I1 prefix14_class=940
cmp P2, P0
mov S0, P0
mov S1, P3
cmovl P0, P2
cmovge S0, P2
cmp S1, P1
cmovg P3, P1
mov S2, S0
cmovg P1, S1
cmovg S1, P3
cmp P1, S0
cmovge S2, P1
cmovge P1, S0
mov S2, P1
