# n=5 model=out iset=I1 prefix14_class=465
cmp P3, P0
cmovge S2, P3
mov S1, P1
cmovl S2, P0
cmovle P0, P3
cmp P1, P2
cmovge P1, P2
cmovge P2, S1
mov S1, P0
cmp P1, S1
cmovle P0, P1
cmovl P1, S1
mov P3, S2
mov P0, P1
