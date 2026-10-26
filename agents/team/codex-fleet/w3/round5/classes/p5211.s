# n=5 model=out iset=I1 prefix14_class=5211
mov S2, P1
cmp P1, P0
cmovle P1, P0
cmovge S2, P0
cmp P2, P3
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
mov P0, P1
cmp P3, S2
cmovge S0, P3
cmovg P3, S2
cmovge S2, S0
cmp P2, P1
