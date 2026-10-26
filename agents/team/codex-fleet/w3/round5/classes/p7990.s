# n=5 model=out iset=I1 prefix14_class=7990
cmp P1, P3
mov S1, P0
cmovg S0, P3
cmovg P3, P1
cmovg P1, S0
cmp P0, P2
mov S2, P1
cmovge P0, P2
cmovg P2, S1
mov S1, P3
cmp S2, P0
cmovl S2, P0
cmovge P1, P0
cmp P2, S1
