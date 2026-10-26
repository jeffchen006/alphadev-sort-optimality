# n=5 model=out iset=I1 prefix14_class=6941
mov S1, P3
cmp S1, P2
cmovge P3, P2
cmovl S1, P2
mov P2, S1
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovg P1, P0
cmp S1, P1
cmovge S1, P1
cmovg P1, P2
mov P1, S1
cmp S0, P3
