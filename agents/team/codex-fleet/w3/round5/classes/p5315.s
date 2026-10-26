# n=5 model=out iset=I1 prefix14_class=5315
cmp P1, P3
mov S1, P3
cmovle S1, P1
cmovg P3, P1
mov S0, P0
cmp P0, P2
cmovle P0, P2
cmovge S0, P2
mov S2, S0
cmp S0, S1
cmovl S0, S1
cmovle S1, S2
cmp P0, P3
cmovle S2, P3
