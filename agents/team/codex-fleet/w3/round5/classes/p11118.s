# n=5 model=out iset=I1 prefix14_class=11118
mov S2, P3
mov S0, P0
cmp P2, S2
cmovle S2, P2
cmovg P3, P2
cmp S0, P1
cmovle P0, P1
cmovl P1, S0
cmp P0, P3
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P1, S2
mov P2, P3
