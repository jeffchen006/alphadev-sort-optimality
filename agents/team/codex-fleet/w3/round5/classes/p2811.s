# n=5 model=out iset=I1 prefix14_class=2811
mov S1, P1
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
mov S2, P0
cmp P3, S2
cmovl P0, P3
cmovl P3, S2
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
cmp P0, S1
cmovle P2, P0
