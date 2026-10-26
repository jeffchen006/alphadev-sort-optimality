# n=5 model=out iset=I1 prefix14_class=5095
cmp P3, P2
mov S1, P1
cmovle S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P0, S1
cmovg S1, P0
cmovg P0, P1
cmp S2, P0
mov S0, S2
cmovle S0, P0
cmovle P0, S2
cmp S1, P3
cmovl P2, P3
