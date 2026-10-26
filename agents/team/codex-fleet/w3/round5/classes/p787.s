# n=5 model=out iset=I1 prefix14_class=787
cmp P3, P2
mov S2, P0
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp P0, P1
cmovg P0, P1
cmovl S2, P1
cmp S2, P3
mov S0, P2
mov P1, S2
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
