# n=5 model=out iset=I1 prefix14_class=3505
mov S2, P0
cmp P1, S2
mov S1, P3
cmovge S2, P1
cmovg P1, P0
cmp P2, P3
cmovl S1, P2
cmovle P2, P3
cmp P1, S1
cmovle P0, P1
cmovle P1, S1
cmovl S1, P0
mov P3, S2
cmp P2, S2
