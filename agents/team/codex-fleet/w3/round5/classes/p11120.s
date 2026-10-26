# n=5 model=out iset=I1 prefix14_class=11120
mov S2, P3
cmp P2, P3
cmovg P3, P2
cmovle S2, P2
mov S1, P0
cmp S1, P1
cmovl P0, P1
cmovle P1, S1
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
mov P0, P3
mov S0, S2
