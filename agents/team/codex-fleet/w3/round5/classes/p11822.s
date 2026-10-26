# n=5 model=out iset=I1 prefix14_class=11822
cmp P3, P0
mov S2, P2
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp S2, P1
cmovle P2, P1
cmovl P1, S2
cmp P2, P3
mov S2, P2
cmovl S2, P3
cmovg P2, P3
cmp P1, P0
cmovle S2, P0
