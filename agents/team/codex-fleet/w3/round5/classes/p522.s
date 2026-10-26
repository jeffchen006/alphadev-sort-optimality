# n=5 model=out iset=I1 prefix14_class=522
cmp P0, P3
cmovge S1, P0
mov S0, P1
cmovge P0, P3
cmovge P3, S1
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
mov P1, P0
cmp S0, P1
cmovl P1, S0
cmovg P0, S0
mov S2, P3
cmovl S0, P0
