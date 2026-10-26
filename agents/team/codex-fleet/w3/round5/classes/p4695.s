# n=5 model=out iset=I1 prefix14_class=4695
mov S2, P2
mov S1, P0
cmp P1, S2
cmovle P2, P1
cmovge S2, P1
cmp S1, P3
cmovg S1, P3
cmovl P0, P3
cmp P0, S2
cmovge P3, S2
cmovge S2, P0
cmovg P0, P3
cmp P2, S1
cmovle P3, P2
