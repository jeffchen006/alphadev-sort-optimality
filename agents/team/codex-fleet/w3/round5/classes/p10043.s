# n=5 model=out iset=I1 prefix14_class=10043
mov S1, P1
cmp P3, P0
cmovg S2, P3
cmovg P3, P0
cmovg P0, S2
cmp S1, P2
cmovge S1, P2
cmovl P1, P2
cmp P0, P1
cmovle P2, P1
cmovg P2, P0
cmovg P0, P1
cmp S1, P3
cmovle P1, S1
