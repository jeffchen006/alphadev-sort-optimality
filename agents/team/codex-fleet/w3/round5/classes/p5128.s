# n=5 model=out iset=I1 prefix14_class=5128
mov S1, P3
cmp P3, P2
mov S2, P0
cmovle S1, P2
cmovle P2, P3
cmp P1, S2
cmovle S2, P1
mov S0, S2
cmovl P1, P0
cmp P2, S0
cmovge S0, P2
cmovle S2, P2
cmp P1, S1
cmovg P0, S1
