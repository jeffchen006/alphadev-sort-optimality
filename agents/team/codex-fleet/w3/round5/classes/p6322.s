# n=5 model=out iset=I1 prefix14_class=6322
mov S0, P1
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmp P0, P2
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
cmp P0, P3
cmovle P1, P0
cmovg P1, P3
cmovle P0, P3
cmp S0, P2
cmovg P0, P2
