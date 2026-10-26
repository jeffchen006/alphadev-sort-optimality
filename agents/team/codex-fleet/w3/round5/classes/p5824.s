# n=5 model=out iset=I1 prefix14_class=5824
cmp P3, P1
cmovg S1, P1
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
mov S0, S1
cmovle P2, S2
cmp S1, P2
cmovge S1, P2
cmovle S0, P2
mov P2, P1
cmp P2, P0
