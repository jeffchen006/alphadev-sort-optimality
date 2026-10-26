# n=5 model=out iset=I1 prefix14_class=4197
mov S1, P1
cmp P3, P0
mov S2, P0
cmovge S2, P3
cmovl P0, P3
cmovg P3, P0
cmp P1, P2
cmovl S1, P2
cmovl P2, P1
cmp P2, P3
cmovle P3, P2
mov P3, S1
cmovl P2, P0
cmovge P0, P2
