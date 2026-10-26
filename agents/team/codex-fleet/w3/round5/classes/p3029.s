# n=5 model=out iset=I1 prefix14_class=3029
mov S1, P1
cmp P3, P2
mov S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P0, P1
cmovle P1, P0
cmovg S1, P0
mov P0, P2
cmp P0, P1
cmovl P2, P1
cmovle P1, P0
cmovl P0, P2
cmp S1, P3
