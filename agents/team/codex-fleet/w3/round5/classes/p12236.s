# n=5 model=out iset=I1 prefix14_class=12236
mov S0, P0
cmp S0, P3
mov S2, P1
cmovg S0, P3
cmovle P0, P3
cmp P2, S2
cmovl S2, P2
cmovg P1, P2
cmp S2, S0
cmovle S1, S2
cmovl S2, S0
cmovle S0, S1
cmp P0, P1
cmovle P2, P0
