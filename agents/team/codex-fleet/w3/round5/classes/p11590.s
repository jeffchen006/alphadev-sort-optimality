# n=5 model=out iset=I1 prefix14_class=11590
mov S1, P0
cmp S1, P1
cmovle P0, P1
cmovg S1, P1
mov S0, P0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovg S2, P2
cmp S2, S1
cmovle P2, S1
cmovle S1, S2
cmovl S2, P2
cmp P0, P3
