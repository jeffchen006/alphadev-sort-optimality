# n=5 model=out iset=I1 prefix14_class=9076
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmovl P2, S0
cmp P0, P1
cmovle S2, P0
cmovge S2, P1
cmovle P0, P1
cmovle P1, S2
cmp S2, P2
cmovle P1, P2
cmovg S2, P2
mov S1, P0
cmp P3, P0
