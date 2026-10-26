# n=5 model=out iset=I1 prefix14_class=2651
mov S2, P0
cmp P0, P3
cmovge S2, P3
mov S0, P1
cmovg P3, P0
cmp P2, P1
mov P0, P3
cmovle P1, P2
cmovg S0, P2
cmp S0, P0
cmovl P3, S0
cmovle S0, P0
cmp S2, P1
cmovl P0, S2
