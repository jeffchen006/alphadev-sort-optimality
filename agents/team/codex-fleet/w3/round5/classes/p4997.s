# n=5 model=out iset=I1 prefix14_class=4997
cmp P0, P3
cmovle S0, P3
mov S2, P2
cmovg S0, P0
cmovl P3, P0
cmovle P0, S0
cmp P1, P2
cmovg P2, P1
cmovl S2, P1
cmp S2, P3
cmovl P1, P3
cmovle P3, S2
cmovl S2, P1
cmp S0, P2
