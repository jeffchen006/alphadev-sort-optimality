# n=5 model=out iset=I1 prefix14_class=4894
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
mov S2, P3
cmovl P1, P2
cmovle P2, S0
cmp P0, P3
cmovle S2, P0
cmovl P0, P3
cmp S2, P2
cmovg P2, S2
cmovg S2, S0
cmp P1, P0
cmovge S2, P0
