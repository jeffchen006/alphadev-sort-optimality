# n=5 model=out iset=I1 prefix14_class=14404
cmp P3, P1
cmovl S2, P3
cmovge S2, P1
mov S1, P2
cmovle P3, P1
cmp S1, P0
cmovg S1, P0
cmovg P0, P2
mov S0, S2
cmp S2, S1
cmovg S2, S1
cmovle S0, S1
cmp P0, P3
cmovle S1, S0
