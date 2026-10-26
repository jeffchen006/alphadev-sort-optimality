# n=5 model=out iset=I1 prefix14_class=10945
mov S2, P1
cmp P3, P1
cmovl S2, P3
cmovl P3, P1
cmp P0, P2
cmovg P1, P0
cmovg P0, P2
cmovg P2, P1
mov S1, P3
cmp P2, S1
cmovle S1, P2
cmovg P3, P2
cmp S2, P0
cmovl P2, P0
