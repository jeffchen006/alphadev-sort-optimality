# n=5 model=out iset=I1 prefix14_class=3466
mov S1, P0
cmp P1, S1
cmovge P0, P1
cmovg P1, S1
mov S0, P3
cmp P3, P2
cmovg P3, P2
cmovl S0, P2
mov S1, S0
cmp P1, P3
cmovge P2, P3
cmovge P3, P1
cmovg P1, P2
cmp P0, S1
