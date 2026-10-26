# n=5 model=out iset=I1 prefix14_class=10710
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovge S2, P0
cmp P2, P3
mov S0, P3
cmovg P3, P2
cmovle S0, P2
cmp P3, S2
cmovle S1, P3
cmovle P3, S2
mov P0, S0
cmovl S2, S1
cmp P0, P1
