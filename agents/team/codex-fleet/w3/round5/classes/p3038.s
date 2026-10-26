# n=5 model=out iset=I1 prefix14_class=3038
mov S2, P2
cmp P0, P2
cmovle P2, P0
cmovl P0, S2
mov S1, P3
cmp P1, S1
cmovl S1, P1
cmovge P3, P1
cmp P2, S1
mov P1, P2
cmovl P2, S1
cmovle S1, P1
mov S1, P3
cmp P0, P3
