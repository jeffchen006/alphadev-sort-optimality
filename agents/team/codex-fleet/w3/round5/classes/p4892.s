# n=5 model=out iset=I1 prefix14_class=4892
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovle P1, P2
mov S2, P0
cmovle P2, S0
cmp P3, P0
cmovl S2, P3
cmovl P3, P0
cmp S2, S0
cmovg P2, S2
cmovg S2, S0
cmp P1, P3
cmovle S2, P1
