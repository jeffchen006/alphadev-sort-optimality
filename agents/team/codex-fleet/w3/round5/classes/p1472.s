# n=5 model=out iset=I1 prefix14_class=1472
mov S0, P2
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
cmovl P2, P0
cmovl P0, S0
cmp P3, P2
cmovge S0, P2
cmovle S0, P3
cmovle P3, P2
mov P2, P1
cmp P0, P1
