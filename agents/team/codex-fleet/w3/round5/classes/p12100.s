# n=5 model=out iset=I1 prefix14_class=12100
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
mov S0, P0
cmovl S1, P2
cmp P1, S0
cmovle S0, P1
mov S2, S0
cmovle P1, P0
cmp S2, P3
cmovl S0, P3
cmovg S2, P3
cmp P1, S1
cmovg P0, S1
