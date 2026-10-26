# n=5 model=out iset=I1 prefix14_class=2523
mov S2, P1
mov S1, P0
cmp P2, S2
cmovl S2, P2
cmovl P2, P1
mov P1, P2
cmp P0, P3
cmovl P0, P3
cmovle P3, S1
cmp P1, P0
cmovg P2, P0
cmovge P0, P1
cmp P3, S2
cmovge P1, P3
