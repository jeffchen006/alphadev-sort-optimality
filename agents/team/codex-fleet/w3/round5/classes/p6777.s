# n=5 model=out iset=I1 prefix14_class=6777
mov S1, P2
cmp S1, P1
mov S0, P3
cmovl P2, P1
cmovge S1, P1
cmp P0, S0
cmovge P3, P0
cmovg P0, S0
cmp P3, P2
cmovg S0, P3
mov P1, S1
cmovg P3, P2
cmovg P2, S0
cmp S1, P0
