# n=5 model=out iset=I1 prefix14_class=3617
mov S0, P1
cmp S0, P3
cmovle S0, P3
cmovle P3, P1
mov P1, P2
cmp P0, P1
cmovle P2, P0
mov S2, P2
cmovle P0, P1
cmp P3, S2
cmovl P2, P3
cmovle P3, S2
cmp S0, P0
cmovl P2, P0
