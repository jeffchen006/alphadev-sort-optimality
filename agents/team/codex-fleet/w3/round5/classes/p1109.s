# n=5 model=out iset=I1 prefix14_class=1109
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P1, P3
mov S1, P0
cmovg S2, P1
cmovle S2, P3
cmovg P1, P3
cmp S1, S2
cmovle S1, S2
cmovle S2, P0
cmp P2, P1
cmovge S1, P2
