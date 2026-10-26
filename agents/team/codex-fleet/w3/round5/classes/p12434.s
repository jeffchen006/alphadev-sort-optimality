# n=5 model=out iset=I1 prefix14_class=12434
mov S0, P0
cmp S0, P3
cmovl S0, P3
cmovle P3, P0
cmp P2, P1
mov P0, P1
cmovl P1, P2
cmovle P2, P0
cmp P3, P1
cmovle P0, P1
cmovle P1, P3
cmovle P3, P0
cmp P2, S0
cmovle P1, P2
