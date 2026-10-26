# n=5 model=out iset=I1 prefix14_class=10146
mov S2, P1
cmp P2, S2
cmovg P1, P2
cmovle S2, P2
cmp P0, P3
cmovle S1, P0
mov P2, P1
cmovle P0, P3
cmovl P3, S1
mov S0, P3
cmp P0, P2
cmovg P1, P0
cmovl P2, P0
cmp S2, S0
