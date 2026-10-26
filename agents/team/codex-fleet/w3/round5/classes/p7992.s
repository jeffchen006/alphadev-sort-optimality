# n=5 model=out iset=I1 prefix14_class=7992
cmp P0, P2
cmovl S2, P0
cmovge S2, P2
cmovg P2, P0
mov S0, P3
cmp S0, P1
cmovg S0, P1
cmovle P3, P1
cmp S2, S0
cmovle P1, S2
cmovle S2, S0
cmovg P1, S0
cmp P3, P2
cmovg P0, P3
