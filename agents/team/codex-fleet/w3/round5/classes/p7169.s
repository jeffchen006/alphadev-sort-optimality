# n=5 model=out iset=I1 prefix14_class=7169
cmp P2, P1
cmovg S2, P2
cmovle S2, P1
cmovg P2, P1
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
mov S0, P2
cmovl P3, S1
cmp P2, P0
cmovl S0, P0
cmovg P2, P0
mov P0, S2
cmp S2, P3
