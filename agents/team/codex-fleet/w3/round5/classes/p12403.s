# n=5 model=out iset=I1 prefix14_class=12403
cmp P1, P3
mov S1, P3
cmovg S1, P1
mov S2, P0
cmovl P3, P1
cmp P2, S2
cmovg S2, P2
cmovl P0, P2
cmp P3, P0
cmovle P1, P0
cmovle P0, P3
cmovle P3, P1
cmp S2, S1
mov S0, S1
