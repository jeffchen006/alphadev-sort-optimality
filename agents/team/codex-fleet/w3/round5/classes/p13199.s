# n=5 model=out iset=I1 prefix14_class=13199
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovg S1, P2
mov P2, P1
cmp P0, P1
cmovle P2, P0
cmovl P0, P1
mov P1, P2
cmp P1, P3
cmovl P2, P3
cmovg P1, P3
cmp S1, P0
cmovge S0, S1
