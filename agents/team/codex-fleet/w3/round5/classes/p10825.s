# n=5 model=out iset=I1 prefix14_class=10825
cmp P2, P1
mov S1, P2
mov S0, P3
cmovge S1, P1
cmovl P2, P1
cmp P0, P3
cmovge P3, P0
cmovg P0, S0
cmp P2, P3
cmovg P1, P2
cmovg P2, P3
cmovg P3, P1
cmp P0, S1
cmovg P3, P0
