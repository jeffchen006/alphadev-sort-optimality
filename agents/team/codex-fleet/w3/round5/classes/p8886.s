# n=5 model=out iset=I1 prefix14_class=8886
cmp P0, P1
cmovge S0, P0
cmovg P0, P1
cmovl S0, P1
cmp P3, P2
cmovl S2, P3
cmovge S2, P2
cmovg P2, P3
mov P1, S2
cmp S0, P2
cmovg P3, P2
cmovge P2, S0
cmovg S0, P3
cmp P1, P0
