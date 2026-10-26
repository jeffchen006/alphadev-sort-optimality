# n=5 model=out iset=I1 prefix14_class=9523
cmp P0, P1
mov S0, P2
cmovge S2, P0
cmovle S2, P1
cmovle P1, P0
cmp S0, P3
cmovl S0, P3
cmovg P2, P3
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmovg S1, P2
cmp S0, S2
cmovg P0, S2
