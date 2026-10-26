# n=5 model=out iset=I1 prefix14_class=12271
cmp P2, P0
cmovge S0, P0
cmovl S0, P2
cmovg P0, P2
cmp P3, P1
cmovg S1, P1
mov P2, S0
cmovge P1, P3
cmovg P3, S1
cmp S0, P3
cmovg P2, P3
cmovg P3, S0
mov P2, P0
cmp P1, P0
