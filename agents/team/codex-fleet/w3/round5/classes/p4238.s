# n=5 model=out iset=I1 prefix14_class=4238
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovg P3, S1
mov S2, P2
cmp P1, P2
cmovg P2, P1
cmovg P1, S2
cmp P3, P1
cmovge S1, P3
cmovl S1, P1
cmovle P1, P3
cmp P2, P0
cmovle P3, P2
