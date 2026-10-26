# n=5 model=out iset=I1 prefix14_class=3703
cmp P2, P3
cmovle S1, P2
cmovge S1, P3
cmovl P2, P3
mov P3, P0
cmp P0, P1
cmovle P3, P1
mov S2, S1
cmovle P1, P0
cmp P1, S1
cmovle S1, P1
mov S1, P3
cmovg S2, P1
mov S0, S2
