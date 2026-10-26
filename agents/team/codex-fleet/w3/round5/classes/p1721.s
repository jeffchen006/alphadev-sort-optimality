# n=5 model=out iset=I1 prefix14_class=1721
mov S2, P1
cmp P0, P1
cmovle P1, P0
cmovge S2, P0
cmp P2, P3
mov P0, P1
mov S1, P3
cmovl P3, P2
cmovl P2, S1
cmp P3, P1
cmovge P1, P3
cmovl P0, P3
cmp P2, S2
cmovg S1, S2
