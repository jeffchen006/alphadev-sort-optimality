# n=5 model=out iset=I1 prefix14_class=8485
cmp P1, P0
mov S1, P1
cmovle P1, P0
cmovg S1, P0
cmp P2, P3
cmovle P0, P2
cmovl P2, P3
cmovle P3, P0
mov S0, P1
cmp S0, P2
cmovle P1, P2
cmovge S0, P2
mov P1, S1
cmp S1, P3
