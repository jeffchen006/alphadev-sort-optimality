# n=5 model=out iset=I1 prefix14_class=88
mov S0, P1
cmp P2, S0
cmovg P1, P2
cmovg P2, S0
mov S1, P3
cmp P0, S1
cmovl P3, P0
cmovg S1, P0
cmovge P0, P3
cmp P0, P2
cmovge P3, P2
cmovge P2, P0
mov S0, S1
cmp S1, P1
