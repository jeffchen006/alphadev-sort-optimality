# n=5 model=out iset=I1 prefix14_class=764
cmp P0, P1
cmovg S1, P1
cmovle S1, P0
cmovle P0, P1
mov S2, P2
cmp P2, P3
cmovg P2, P3
cmovl S2, P3
cmp S2, P0
cmovle S0, P0
cmovle P0, S2
cmovg S0, S2
mov S0, P2
cmp P2, S1
