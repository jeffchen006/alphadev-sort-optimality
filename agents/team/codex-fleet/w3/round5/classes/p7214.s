# n=5 model=out iset=I1 prefix14_class=7214
cmp P3, P1
cmovl S0, P1
mov S1, P2
cmovge S0, P3
cmovg P3, P1
cmp P0, P2
cmovle P2, P0
cmovg S1, P0
mov P1, P2
cmp P1, P3
cmovle P2, P3
cmovg P1, P3
cmp S1, S0
cmovle S2, S0
