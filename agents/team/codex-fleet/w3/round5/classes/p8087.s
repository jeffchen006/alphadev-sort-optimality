# n=5 model=out iset=I1 prefix14_class=8087
mov S1, P2
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmp P1, P3
cmovg P2, P1
cmovg P1, P3
cmovg P3, P2
mov S0, P1
cmp P0, S0
cmovge S0, P0
cmovl P1, P0
cmovl P0, S0
cmp P3, S1
