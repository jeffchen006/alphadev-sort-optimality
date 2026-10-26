# n=5 model=out iset=I1 prefix14_class=5209
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovg S2, P3
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P0, S2
mov P3, P2
mov S0, P0
cmovg P0, S2
cmovge S2, S0
cmp P1, P2
