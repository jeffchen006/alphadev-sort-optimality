# n=5 model=out iset=I1 prefix14_class=4035
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovge P2, S1
mov S2, P0
cmp P3, P0
cmovg S2, P3
cmovle P0, P3
mov S1, P0
cmp P1, S1
cmovle P0, P1
cmovg S1, P1
cmp S2, P2
cmovl P0, S2
