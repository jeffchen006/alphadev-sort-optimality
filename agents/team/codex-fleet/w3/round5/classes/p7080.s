# n=5 model=out iset=I1 prefix14_class=7080
mov S1, P1
cmp P3, S1
cmovg S1, P3
cmovge P3, P1
cmp P0, P2
cmovg P1, P0
cmovg P0, P2
mov S0, P3
cmovg P2, P1
cmp P0, S0
cmovge P3, P0
cmovl S0, P0
mov S2, P2
cmp P2, S1
