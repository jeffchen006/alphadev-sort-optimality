# n=5 model=out iset=I1 prefix14_class=8854
cmp P1, P3
mov S2, P1
cmovge P1, P3
mov S1, P0
cmovl S2, P3
cmp P0, P2
cmovge P0, P2
mov S0, S2
cmovg P2, S1
cmp P2, S0
cmovg S2, P2
cmovge P2, S0
cmp P1, P0
cmovl S1, P1
