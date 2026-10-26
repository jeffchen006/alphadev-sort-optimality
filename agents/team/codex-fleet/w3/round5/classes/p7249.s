# n=5 model=out iset=I1 prefix14_class=7249
cmp P2, P1
mov S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P3, P0
cmovle P2, P0
cmovl P0, P3
mov S0, P0
cmovle P3, P2
cmp P0, P1
cmovle S0, P1
cmovg P0, P1
cmp S1, P3
cmovl P0, S1
