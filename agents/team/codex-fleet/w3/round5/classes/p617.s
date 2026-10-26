# n=5 model=out iset=I1 prefix14_class=617
mov S0, P0
cmp P1, P3
mov S1, P3
cmovg S1, P1
cmovge P1, P3
cmp S0, P2
cmovge S0, P2
cmovg P2, P0
mov P0, S1
cmp P2, P0
cmovg S1, P2
cmovl P0, P2
cmp P1, S0
mov P3, S0
