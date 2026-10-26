# n=5 model=out iset=I1 prefix14_class=2407
mov S2, P0
cmp P2, S2
mov S1, P3
cmovge P0, P2
cmovg P2, S2
cmp P1, S1
cmovle P3, P1
cmovg S1, P1
cmp S1, P0
cmovge P1, S1
cmovge S1, P0
cmovle P1, P0
cmp P3, P2
cmovl P1, P2
