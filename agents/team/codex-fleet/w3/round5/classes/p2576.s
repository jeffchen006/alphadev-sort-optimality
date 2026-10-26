# n=5 model=out iset=I1 prefix14_class=2576
mov S1, P2
mov S0, P3
cmp S0, P0
cmovg S0, P0
cmovl P3, P0
cmp P1, S1
cmovge P2, P1
cmovge P1, S1
cmp P3, P2
cmovl P0, P2
cmovge P0, P3
cmovg P3, P2
cmp P1, S0
cmovge P2, P1
