# n=5 model=out iset=I1 prefix14_class=13036
mov S0, P2
cmp P0, S0
cmovg S0, P0
cmovle P2, P0
mov P0, P1
cmp P1, P3
cmovl P1, P3
cmovle P3, P0
cmp P3, P2
cmovle P0, P3
cmovle P3, P2
cmovl P2, P0
cmp S0, P1
mov P2, P3
