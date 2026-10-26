# n=5 model=out iset=I1 prefix14_class=4065
mov S0, P2
cmp P1, S0
cmovg P2, P1
mov S2, P3
cmovle S0, P1
cmp P3, P0
cmovle S2, P0
cmovle P0, P3
cmp S0, P0
cmovg S1, S0
cmovge S0, P0
cmovle S1, P0
cmp P2, S2
cmovl S0, P2
