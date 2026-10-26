# n=5 model=out iset=I1 prefix14_class=14202
mov S2, P2
cmp P2, P0
cmovl S2, P0
mov S0, S2
cmovle P0, P2
cmp P3, P1
cmovg S1, P1
cmovg P1, P3
cmovg P3, S1
cmp S0, P1
cmovge S0, P1
cmovle S2, P1
cmp P3, P0
cmovle P1, P3
