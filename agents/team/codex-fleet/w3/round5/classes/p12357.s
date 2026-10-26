# n=5 model=out iset=I1 prefix14_class=12357
cmp P3, P1
mov S1, P3
cmovl S1, P1
cmovg P3, P1
mov P1, P0
cmp P0, P2
cmovg P1, P2
cmovle P0, P2
mov S2, S1
cmp P3, P1
cmovle S0, P3
cmovle P3, P1
cmovle P1, S0
cmp S1, P0
