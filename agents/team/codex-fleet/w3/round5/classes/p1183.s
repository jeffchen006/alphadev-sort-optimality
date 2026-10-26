# n=5 model=out iset=I1 prefix14_class=1183
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovle P0, S2
mov S0, P3
cmp S0, P2
cmovle S0, P2
cmovg P3, P2
cmp P1, S0
cmovge S2, P1
cmovg P1, S0
cmovg S0, S2
mov P2, P0
cmp P0, P3
