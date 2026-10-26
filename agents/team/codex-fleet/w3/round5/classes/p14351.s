# n=5 model=out iset=I1 prefix14_class=14351
mov S2, P1
cmp S2, P3
cmovl P1, P3
cmovle P3, S2
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
cmovle P0, S0
mov S2, P0
cmp P3, P0
cmovle S2, P3
cmovg P0, P3
mov S2, P1
cmp P2, P1
