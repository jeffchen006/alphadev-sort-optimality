# n=5 model=out iset=I1 prefix14_class=3681
mov S2, P0
cmp P0, P2
cmovle S2, P2
mov S1, P3
cmovle P2, P0
cmp P3, P1
mov S0, P2
cmovle S1, P1
cmovle P1, P3
cmp S0, P1
cmovl S0, P1
cmovle P1, P2
cmp S1, S2
cmovg P2, S2
