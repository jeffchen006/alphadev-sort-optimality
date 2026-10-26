# n=5 model=out iset=I1 prefix14_class=8228
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
cmovle P0, S2
mov S1, P1
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmovg P3, S0
cmp P1, P3
cmovg S1, P3
cmovle P1, P3
mov P3, P1
cmp P2, P0
