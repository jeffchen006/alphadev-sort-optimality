# n=5 model=out iset=I1 prefix14_class=14034
mov S2, P2
cmp P2, P0
cmovg P2, P0
mov S1, P1
cmovg P0, S2
cmp P1, P3
mov S0, P2
cmovg P1, P3
cmovle S1, P3
cmp S1, P0
cmovl S2, P0
cmovle P0, S1
cmovl S1, S2
cmp P2, P1
