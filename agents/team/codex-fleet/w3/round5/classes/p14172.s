# n=5 model=out iset=I1 prefix14_class=14172
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovle P0, S0
mov S2, P1
cmp P3, S2
mov S1, P0
cmovg P1, P3
cmovg P3, S2
cmp P0, P1
cmovge P0, P1
cmovg P1, S1
cmp P3, P2
cmovge S2, P2
