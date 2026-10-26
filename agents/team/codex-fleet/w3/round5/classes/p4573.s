# n=5 model=out iset=I1 prefix14_class=4573
mov S2, P2
mov S0, P3
cmp S2, P1
cmovge S2, P1
cmovge P1, P2
cmp S0, P0
cmovg P3, P0
cmovl S0, P0
mov P2, S0
cmp P1, P2
cmovl P2, P1
mov S1, P2
cmovg S0, P1
mov S0, P3
