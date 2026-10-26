# n=5 model=out iset=I1 prefix14_class=1186
cmp P1, P0
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
mov S2, P3
cmp P3, P2
cmovg P3, P2
cmovle S2, P2
cmp S2, P1
mov P2, P0
cmovge S1, S2
cmovg S2, P1
cmovg P1, S1
cmp P2, P3
