# n=5 model=out iset=I1 prefix14_class=6351
cmp P3, P1
cmovg S1, P3
mov S2, P0
cmovge P3, P1
cmovg P1, S1
cmp S2, P2
cmovg S2, P2
cmovg P2, P0
mov S0, P1
cmp P2, S0
cmovge P1, P2
cmovl S0, P2
cmp S2, P3
mov P1, S0
