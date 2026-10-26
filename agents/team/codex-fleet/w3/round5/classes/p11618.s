# n=5 model=out iset=I1 prefix14_class=11618
cmp P3, P0
mov S0, P0
cmovge P0, P3
cmovge P3, S0
cmp P1, P2
cmovge S0, P1
cmovg P1, P2
cmovg P2, S0
mov S1, P0
cmp P0, P2
mov S2, P1
cmovg P0, P2
cmovl S1, P2
cmp P1, P3
