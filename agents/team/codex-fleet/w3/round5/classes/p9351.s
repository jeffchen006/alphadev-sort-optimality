# n=5 model=out iset=I1 prefix14_class=9351
mov S2, P3
cmp P1, S2
cmovl P3, P1
mov S1, P2
cmovle P1, S2
cmp P0, P2
cmovl P2, P0
cmovle P0, S1
cmp P2, P3
cmovge S1, P3
cmovge P3, P2
cmovg P2, S1
cmp P1, P0
mov S2, P0
