# n=5 model=out iset=I1 prefix14_class=2814
mov S0, P1
cmp P3, P0
mov S2, P3
cmovg S2, P0
cmovg P0, P3
cmovg P3, S2
cmp P2, S0
cmovl P1, P2
cmovl P2, S0
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P3, P1
