# n=5 model=out iset=I1 prefix14_class=5875
mov S2, P0
cmp P2, S2
cmovge S2, P2
cmovg P2, P0
cmp P1, P3
cmovl P0, P3
cmovle P3, P1
cmovl P1, P0
cmp P1, S2
cmovge P0, S2
cmovle P0, P1
cmovge S2, P1
mov S2, P0
cmp P3, P2
