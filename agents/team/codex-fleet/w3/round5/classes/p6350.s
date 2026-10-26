# n=5 model=out iset=I1 prefix14_class=6350
cmp P1, P3
cmovg S1, P1
mov S2, P0
cmovge P1, P3
cmovg P3, S1
cmp S2, P2
cmovg S2, P2
cmovg P2, P0
mov S0, P3
cmp P2, S0
cmovge P3, P2
cmovl S0, P2
cmp S2, P1
mov P3, S0
