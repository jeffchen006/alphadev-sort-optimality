# n=5 model=out iset=I1 prefix14_class=3799
mov S2, P0
cmp P0, P2
cmovg P0, P2
cmovg P2, S2
cmp P3, P1
mov S2, P1
cmovle S2, P3
cmovle P3, P1
cmp P0, S2
cmovle P1, P0
cmovl P0, S2
cmovle S2, P1
cmp P3, P2
mov S2, P0
