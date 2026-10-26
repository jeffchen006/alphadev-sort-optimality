# n=5 model=out iset=I1 prefix14_class=12023
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P2, P1
mov S2, P2
cmovge P2, P1
cmovle S2, P1
cmovle P1, P2
cmp P1, P0
cmovge P1, P0
cmovl P2, P0
mov P1, P3
cmp P1, S2
