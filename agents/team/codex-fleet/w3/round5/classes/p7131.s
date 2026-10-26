# n=5 model=out iset=I1 prefix14_class=7131
mov S2, P0
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
cmovle P1, S0
cmp S2, P3
cmovle S2, P3
cmovg P0, P3
cmp P2, P0
cmovle P3, P0
cmovl P0, P2
cmovg P3, P2
cmp S2, P1
cmovle P2, P1
