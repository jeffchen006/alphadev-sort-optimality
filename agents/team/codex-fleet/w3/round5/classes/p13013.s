# n=5 model=out iset=I1 prefix14_class=13013
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovl P0, S1
cmovge S1, P0
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P3
cmovg S1, P3
cmovl P0, P3
mov P3, P1
cmp P2, P3
