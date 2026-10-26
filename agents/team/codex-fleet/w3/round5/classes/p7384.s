# n=5 model=out iset=I1 prefix14_class=7384
mov S1, P3
cmp P3, P2
cmovl P3, P2
cmovl P2, S1
mov S0, P0
cmp P0, P1
mov S1, P3
cmovge P0, P1
cmovg P1, S0
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmovg P2, S2
cmp P1, P3
