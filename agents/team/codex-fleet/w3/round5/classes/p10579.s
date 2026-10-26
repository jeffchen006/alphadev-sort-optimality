# n=5 model=out iset=I1 prefix14_class=10579
mov S0, P2
cmp P2, P1
mov S1, P3
cmovl S0, P1
cmovle P1, P2
cmp P0, S1
cmovle P3, P0
cmovg S1, P0
cmp S1, S0
cmovle P2, S1
mov S2, P1
cmovl S1, S0
cmovle S0, P2
cmp P3, S2
