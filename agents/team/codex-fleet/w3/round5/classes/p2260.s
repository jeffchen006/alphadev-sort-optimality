# n=5 model=out iset=I1 prefix14_class=2260
mov S2, P3
cmp S2, P0
cmovl P3, P0
cmovg S2, P0
cmp P1, P2
mov P0, P1
cmovg P1, P2
cmovg P2, P0
cmp P2, P3
cmovl P0, P2
cmovl P2, P3
cmovl P3, P0
mov P2, S2
cmp S2, P1
