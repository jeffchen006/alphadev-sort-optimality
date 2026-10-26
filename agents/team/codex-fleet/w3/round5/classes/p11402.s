# n=5 model=out iset=I1 prefix14_class=11402
mov S2, P0
cmp P1, P3
cmovl S0, P3
cmovl P3, P1
cmovl P1, S0
cmp S2, P2
cmovle P0, P2
cmovg S2, P2
mov P2, P0
cmp P1, P0
cmovg P2, P1
cmovl P0, P1
cmp P3, S2
cmovge P1, S2
