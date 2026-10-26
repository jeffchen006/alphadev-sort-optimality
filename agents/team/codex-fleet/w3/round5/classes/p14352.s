# n=5 model=out iset=I1 prefix14_class=14352
mov S2, P2
cmp S2, P3
cmovle P2, P3
cmovl P3, S2
cmp P1, P0
cmovle S0, P1
cmovle P1, P0
cmovle P0, S0
mov S2, P3
cmp P0, P3
cmovle S2, P0
cmovg P3, P0
mov S2, P1
cmp P2, P1
