# n=5 model=out iset=I1 prefix14_class=13803
mov S2, P0
cmp S2, P1
cmovg S2, P1
cmovl P0, P1
mov S1, P2
cmp P2, P3
cmovg S1, P3
cmovl P2, P3
cmp P2, P0
cmovle P1, P0
cmovle P0, P2
cmovle P2, P1
cmp S2, S1
cmovg P2, S2
