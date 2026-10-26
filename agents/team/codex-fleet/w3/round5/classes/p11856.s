# n=5 model=out iset=I1 prefix14_class=11856
mov S1, P1
mov S2, P3
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmp P1, P0
cmovle P1, P0
cmovl P0, S1
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
mov P1, S2
cmovle P2, S1
cmp P1, P0
