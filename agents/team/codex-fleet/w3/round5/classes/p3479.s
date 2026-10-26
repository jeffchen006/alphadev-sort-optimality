# n=5 model=out iset=I1 prefix14_class=3479
mov S1, P2
cmp P1, P2
cmovg S1, P1
mov S2, P0
cmovge P1, P2
cmp S2, P3
cmovle P0, P3
cmovl P3, S2
mov S2, P1
cmp P3, S2
cmovge S2, P3
cmovg P3, P1
cmp P0, S1
mov P3, P0
