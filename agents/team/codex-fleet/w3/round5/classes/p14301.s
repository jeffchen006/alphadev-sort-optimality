# n=5 model=out iset=I1 prefix14_class=14301
mov S1, P3
cmp P1, S1
cmovl P3, P1
cmovg S1, P1
mov S0, P2
cmp P2, P0
cmovl S0, P0
cmovg P2, P0
cmp P2, P3
cmovge P1, P2
cmovge P2, P3
cmovg P3, P1
mov P0, P3
cmp S1, S0
