# n=5 model=out iset=I1 prefix14_class=5132
mov S2, P2
cmp P0, P3
mov S1, P0
cmovle S1, P3
cmovle P3, P0
cmp P1, S2
cmovl S2, P1
mov S0, S2
cmovle P1, P2
cmp P3, S2
cmovg S0, P3
cmovle S2, P3
cmp S1, P1
cmovle P2, S1
