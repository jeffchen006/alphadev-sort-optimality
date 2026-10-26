# n=5 model=out iset=I1 prefix14_class=10844
mov S2, P3
cmp S2, P1
cmovg P3, P1
cmovg P1, S2
mov S2, P0
cmp S2, P2
cmovge P0, P2
cmovg P2, S2
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmovl P1, S2
cmp P0, P3
mov S1, P0
