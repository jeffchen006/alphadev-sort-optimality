# n=5 model=out iset=I1 prefix14_class=5148
cmp P2, P3
cmovle S1, P2
mov S0, P1
cmovl P2, P3
cmovle P3, S1
cmp P0, S0
mov S2, P3
cmovle P1, P0
cmovl P0, S0
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmp P0, P2
mov P3, P2
