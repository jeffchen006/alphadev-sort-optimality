# n=5 model=out iset=I1 prefix14_class=10047
cmp P2, P3
cmovle S2, P2
mov S1, P1
cmovle P2, P3
cmovle P3, S2
mov S0, P2
cmp P0, P1
cmovle P1, P0
cmovle P0, S1
cmp P0, S0
cmovg P2, P0
cmovg P0, S0
cmp P1, P3
cmovl S2, P1
