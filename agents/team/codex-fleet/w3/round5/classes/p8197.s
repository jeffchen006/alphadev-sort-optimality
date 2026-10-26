# n=5 model=out iset=I1 prefix14_class=8197
mov S2, P1
cmp P3, P1
mov S1, P0
cmovl P1, P3
cmovle P3, S2
cmp P2, S1
cmovle S1, P2
cmovle P2, P0
cmp P1, S1
cmovge S2, S1
cmovge S1, P1
cmovge P1, S2
mov P1, P3
cmp P3, P2
