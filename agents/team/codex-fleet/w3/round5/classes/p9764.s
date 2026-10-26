# n=5 model=out iset=I1 prefix14_class=9764
cmp P2, P0
mov S2, P0
mov S1, P3
cmovl P0, P2
cmovle P2, S2
cmp P1, S1
cmovle P3, P1
cmovle P1, S1
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp P0, P3
cmovle P1, P0
