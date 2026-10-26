# n=5 model=out iset=I1 prefix14_class=1731
mov S2, P1
cmp P1, P0
cmovl S2, P0
cmovl P0, P1
cmp P2, P3
cmovle S0, P3
cmovle P3, P2
mov S1, P0
cmovle P2, S0
cmp P3, P0
cmovg S1, P3
cmovl P0, P3
mov P1, P2
cmp S2, P2
