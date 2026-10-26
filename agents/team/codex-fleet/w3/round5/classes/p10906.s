# n=5 model=out iset=I1 prefix14_class=10906
cmp P3, P0
cmovle S1, P3
mov S2, P1
cmovle P3, P0
cmovl P0, S1
cmp P2, P1
cmovle P1, P2
cmovge S2, P2
cmp S2, P3
mov P2, S2
cmovl S2, P3
cmovle P3, P2
cmp P0, P1
cmovle P2, P1
