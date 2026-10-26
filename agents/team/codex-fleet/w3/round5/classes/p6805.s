# n=5 model=out iset=I1 prefix14_class=6805
cmp P2, P3
cmovge S0, P2
cmovle S0, P3
cmovle P3, P2
cmp P1, P0
mov S2, P1
cmovg P1, P0
cmovl S2, P0
cmp S2, S0
cmovg S1, S2
cmovle S1, S0
cmovl S0, S2
cmp P1, P3
cmovle S2, P1
