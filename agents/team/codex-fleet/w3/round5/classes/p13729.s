# n=5 model=out iset=I1 prefix14_class=13729
cmp P1, P3
cmovle S1, P3
mov S2, P2
cmovle P3, P1
cmovle P1, S1
cmp P2, P0
cmovge S2, P0
cmovl P2, P0
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
mov P0, P3
cmovg P2, S0
cmp P3, S2
