# n=5 model=out iset=I1 prefix14_class=11020
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovg P3, S0
mov S2, P2
cmp P1, S2
cmovle P2, P1
cmovl P1, S2
cmp P1, P0
mov S1, P0
cmovge P0, P1
cmovle S1, P1
cmp P3, P2
cmovl P1, P2
