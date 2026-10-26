# n=5 model=out iset=I1 prefix14_class=7435
mov S0, P2
cmp P3, P0
cmovge S2, P0
cmovg P0, P3
cmovg P3, S2
cmp P1, S0
cmovg S0, P1
cmovg P1, P2
mov S1, P3
cmp P3, P1
cmovge P3, P1
cmovge P1, S1
mov P2, P0
cmovl S1, P1
