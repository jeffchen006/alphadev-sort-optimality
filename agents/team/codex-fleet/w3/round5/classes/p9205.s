# n=5 model=out iset=I1 prefix14_class=9205
cmp P3, P2
mov S0, P0
cmovg S1, P2
cmovle S1, P3
cmovle P3, P2
cmp P1, S0
cmovg P0, P1
cmovl S0, P1
mov S2, S1
cmp S1, S0
cmovle S1, S0
cmovge S2, S0
cmp P3, P0
mov S2, S1
