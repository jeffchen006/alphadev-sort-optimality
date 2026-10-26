# n=5 model=out iset=I1 prefix14_class=10466
cmp P2, P1
mov S2, P1
mov S1, P3
cmovl P1, P2
cmovl P2, S2
cmp P0, P3
cmovg S1, P0
cmovle P3, P0
cmp S1, P2
mov P0, P3
cmovge S2, S1
cmovge S1, P2
cmovg P2, S2
cmp P1, P0
