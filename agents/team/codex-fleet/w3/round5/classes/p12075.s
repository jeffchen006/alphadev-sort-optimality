# n=5 model=out iset=I1 prefix14_class=12075
cmp P3, P0
mov S0, P0
cmovl S0, P3
cmovg P0, P3
cmp P2, P1
mov S2, P2
cmovg P2, P1
mov S1, P0
cmovle S2, P1
cmp P2, S0
cmovle P1, S0
cmovl S0, P2
cmovle P2, P1
cmp S2, S1
