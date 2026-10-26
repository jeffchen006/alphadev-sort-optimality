# n=5 model=out iset=I1 prefix14_class=6699
mov S0, P3
cmp P1, P3
cmovle P3, P1
mov S2, P0
cmovl P1, S0
cmp P2, P0
cmovl S2, P2
cmovg P0, P2
cmp P1, P0
cmovle S0, P0
cmovg S0, P1
cmovl P0, P1
cmp S2, P3
cmovle P1, S2
