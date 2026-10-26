# n=5 model=out iset=I1 prefix14_class=11151
mov S0, P2
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmovle P1, S2
cmp P2, P0
cmovle P2, P0
cmovg S0, P0
mov P0, P3
cmp P2, P3
cmovl P3, P2
cmovle P2, P0
cmp P1, S0
cmovge S1, S0
