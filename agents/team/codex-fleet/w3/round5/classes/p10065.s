# n=5 model=out iset=I1 prefix14_class=10065
cmp P3, P1
cmovle S2, P3
mov S1, P2
cmovl P3, P1
cmovl P1, S2
cmp P0, S1
cmovl S1, P0
cmovge P2, P0
mov P0, P3
cmp P0, P2
cmovle P3, P2
mov P3, S1
cmovge P0, P2
cmp P1, P3
