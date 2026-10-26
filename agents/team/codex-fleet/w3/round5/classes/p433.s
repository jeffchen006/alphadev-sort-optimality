# n=5 model=out iset=I1 prefix14_class=433
mov S2, P3
cmp P2, P0
mov S1, P2
cmovl S1, P0
cmovle P0, P2
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmp P0, S2
mov P2, S2
cmovle P2, P0
cmovl P0, S2
cmp P1, S1
mov P2, P1
