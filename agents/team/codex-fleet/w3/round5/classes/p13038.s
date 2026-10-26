# n=5 model=out iset=I1 prefix14_class=13038
mov S1, P3
cmp P0, P3
cmovg P3, P0
cmovl S1, P0
cmp P1, P2
cmovle P0, P1
cmovl P1, P2
cmovle P2, P0
mov S0, P2
cmp S0, S1
cmovle S0, S1
cmovle S1, P2
cmp P1, P3
cmovg P0, P3
