# n=5 model=out iset=I1 prefix14_class=13986
mov S0, P3
cmp P3, P0
cmovg P3, P0
cmovl S0, P0
cmp P2, P1
cmovge P0, P2
cmovg P2, P1
cmovge P1, P0
mov S2, P1
cmp P1, S0
cmovg S2, S0
cmovg S0, P1
mov S1, S2
cmp P3, P2
