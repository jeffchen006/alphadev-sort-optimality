# n=5 model=out iset=I1 prefix14_class=186
cmp P3, P1
mov S1, P2
cmovge S0, P3
cmovle S0, P1
cmovge P3, P1
mov S2, P3
cmp P0, P2
cmovle P2, P0
cmovl P0, S1
mov P1, S0
cmp P2, S2
cmovle P3, P2
cmovge S2, P2
cmp P1, P0
