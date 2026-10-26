# n=5 model=out iset=I1 prefix14_class=7636
cmp P3, P1
mov S2, P0
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P2, S2
cmovle S2, P2
cmovg P0, P2
cmp S2, P1
cmovle P2, S2
cmovl S2, P1
cmovle P1, P2
mov P2, P0
cmp P3, P0
