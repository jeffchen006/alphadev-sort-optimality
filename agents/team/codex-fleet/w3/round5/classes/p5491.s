# n=5 model=out iset=I1 prefix14_class=5491
cmp P0, P3
mov S2, P3
cmovge S2, P0
cmovl P3, P0
mov S1, P2
cmp S1, P1
cmovg S1, P1
cmovle P2, P1
mov P1, S1
cmp P1, P3
cmovle P1, P3
cmovle P3, S1
cmp S2, P2
cmovle P0, S2
