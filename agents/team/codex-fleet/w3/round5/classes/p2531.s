# n=5 model=out iset=I1 prefix14_class=2531
mov S2, P3
cmp P2, S2
mov S1, P1
cmovle S2, P2
cmovl P2, P3
cmp S1, P0
cmovl S1, P0
cmovle P0, P1
mov S0, P2
cmp P2, S1
cmovg P2, S1
cmovl S0, S1
mov S0, P0
cmovl S1, P2
