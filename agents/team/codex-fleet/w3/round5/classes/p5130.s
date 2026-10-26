# n=5 model=out iset=I1 prefix14_class=5130
cmp P0, P2
mov S2, P3
mov S1, P0
cmovl S1, P2
cmovle P2, P0
cmp P1, S2
cmovle S2, P1
mov S0, S2
cmovle P1, P3
cmp P2, S2
cmovge S0, P2
cmovle S2, P2
cmp P1, S1
cmovle P3, P1
