# n=5 model=out iset=I1 prefix14_class=7460
cmp P1, P0
mov S0, P0
cmovge S0, P1
cmovle P0, P1
mov S2, P3
cmp P2, S2
cmovle P3, P2
cmovl P2, S2
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
cmovle P3, S1
mov P1, P2
cmp P1, S0
