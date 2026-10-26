# n=5 model=out iset=I1 prefix14_class=10812
mov S2, P3
cmp P1, S2
cmovge P3, P1
cmovl S2, P1
cmp P2, P0
cmovg S1, P2
cmovle S1, P0
cmovle P0, P2
cmp P3, S1
cmovl P2, P3
cmovl P3, S1
cmovl S1, P2
mov P3, S2
cmp P0, S2
