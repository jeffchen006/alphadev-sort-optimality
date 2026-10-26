# n=5 model=out iset=I1 prefix14_class=5140
mov S1, P0
cmp P2, P0
cmovle P0, P2
cmovg S1, P2
cmp P3, P1
mov S2, P0
cmovl P2, P1
cmovl P1, P3
cmovl P3, P2
cmp P0, P1
cmovge S2, P1
cmovg P1, P0
mov S2, S1
cmp P3, S2
