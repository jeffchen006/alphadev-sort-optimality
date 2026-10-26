# n=5 model=out iset=I1 prefix14_class=9763
mov S2, P0
mov S1, P3
cmp P2, P0
cmovle P0, P2
cmovl P2, S2
cmp P1, S1
cmovle P3, P1
cmovle P1, S1
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp P0, P3
mov S1, P2
