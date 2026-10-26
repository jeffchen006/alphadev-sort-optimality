# n=5 model=out iset=I1 prefix14_class=11153
cmp P3, P1
cmovl S1, P3
cmovl P3, P1
mov S2, P2
cmovl P1, S1
cmp P2, P0
cmovge S2, P0
cmovle P2, P0
mov P0, P3
cmp P2, P3
cmovle P3, P2
cmovle P2, P0
cmp P1, S2
mov P2, S2
