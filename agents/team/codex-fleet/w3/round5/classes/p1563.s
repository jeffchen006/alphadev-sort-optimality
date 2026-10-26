# n=5 model=out iset=I1 prefix14_class=1563
mov S1, P3
cmp P2, S1
cmovge P3, P2
cmovge P2, S1
mov S1, P2
cmp P0, P1
mov S0, P0
cmovl S0, P1
cmovge P0, P1
cmp P2, P0
cmovg S1, P0
cmovg P0, P2
cmp P3, S0
mov S2, S0
