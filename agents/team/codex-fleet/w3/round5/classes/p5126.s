# n=5 model=out iset=I1 prefix14_class=5126
mov S1, P1
cmp S1, P0
cmovl P1, P0
mov S2, P2
cmovle P0, S1
cmp P2, P3
cmovl P2, P3
cmovg S2, P3
mov P3, P0
cmp S2, P0
cmovg P3, S2
cmovle P0, S2
mov P0, P2
cmp P1, P0
