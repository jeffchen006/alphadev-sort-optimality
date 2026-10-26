# n=5 model=out iset=I1 prefix14_class=10056
cmp P0, P3
cmovle S0, P0
cmovl P0, P3
mov S1, P1
cmovl P3, S0
cmp P2, P1
cmovle P1, P2
cmovle P2, S1
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
mov S2, P3
cmp P1, P3
