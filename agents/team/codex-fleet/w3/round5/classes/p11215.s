# n=5 model=out iset=I1 prefix14_class=11215
mov S1, P0
cmp P3, P0
cmovl P0, P3
mov S2, P1
cmovle P3, S1
cmp P1, P2
cmovl P1, P2
cmovl P2, S2
cmp P1, P3
mov S1, P3
cmovge S1, P1
cmovg P1, P3
cmp P0, P2
cmovg S1, P2
