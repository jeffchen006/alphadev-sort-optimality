# n=5 model=out iset=I1 prefix14_class=321
cmp P1, P2
mov S2, P3
cmovge S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P0, P3
cmovge P3, P0
cmovl S2, P0
cmovg P0, S2
cmp P1, S2
cmovle P0, P1
cmovle P1, S2
mov S2, P1
cmp P2, P3
