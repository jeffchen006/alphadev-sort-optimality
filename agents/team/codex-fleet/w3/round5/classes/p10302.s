# n=5 model=out iset=I1 prefix14_class=10302
cmp P1, P0
cmovle S1, P1
cmovg S1, P0
cmovle P1, P0
mov S2, P1
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
cmp P3, S2
cmovle P1, P3
cmovge S2, P3
cmp S1, P2
cmovl S2, P2
