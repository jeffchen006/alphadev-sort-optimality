# n=5 model=out iset=I1 prefix14_class=2753
cmp P3, P0
cmovge S1, P3
cmovle S1, P0
cmovge P3, P0
mov P0, P1
cmp P0, P2
cmovge P0, P2
cmovl P1, P2
cmp P1, S1
cmovle S2, S1
cmovl S1, P1
mov P2, P0
cmovle P1, S2
cmp P0, P3
