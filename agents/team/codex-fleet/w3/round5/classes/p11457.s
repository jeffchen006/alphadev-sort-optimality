# n=5 model=out iset=I1 prefix14_class=11457
cmp P0, P2
mov S2, P2
cmovl S2, P0
cmovle P0, P2
cmp P3, P1
mov S1, S2
cmovg P2, P1
cmovg P1, P3
cmovg P3, P2
cmp P3, S2
cmovge S1, P3
cmovl S2, P3
cmp P1, P0
cmovge P3, P0
