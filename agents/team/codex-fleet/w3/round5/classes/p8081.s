# n=5 model=out iset=I1 prefix14_class=8081
mov S1, P3
cmp P1, S1
cmovge P3, P1
cmovg P1, S1
cmp P0, P2
cmovge S0, P0
cmovg P0, P2
mov S1, P0
cmovg P2, S0
cmp P1, S1
cmovl S1, P1
cmovge P0, P1
cmp P2, P3
cmovg P1, P0
