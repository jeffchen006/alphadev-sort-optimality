# n=5 model=out iset=I1 prefix14_class=12642
mov S2, P0
cmp P2, S2
mov S1, P1
cmovg P0, P2
cmovl S2, P2
cmp P3, P1
cmovle P1, P3
cmovle P3, S1
cmp S2, P1
cmovle S1, P1
cmovl P1, S2
cmovle S2, S1
cmp P3, P0
cmovl S1, P3
