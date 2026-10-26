# n=5 model=out iset=I1 prefix14_class=11559
mov S0, P3
mov S1, P2
cmp P0, S1
cmovle S1, P0
cmovg P2, P0
cmp P1, P3
cmovl S0, P1
mov S2, S1
cmovle P1, P3
cmp S0, S2
cmovl S1, S0
cmovl S0, S2
cmp P1, P2
cmovg S2, S0
