# n=5 model=out iset=I1 prefix14_class=711
cmp P3, P2
cmovle S0, P3
cmovge S0, P2
mov S2, P1
cmovle P3, P2
cmp P1, P0
cmovg S2, P0
cmovle P1, P0
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
mov P3, S2
cmp S2, S0
