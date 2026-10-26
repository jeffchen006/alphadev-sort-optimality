# n=5 model=out iset=I1 prefix14_class=408
mov S1, P0
cmp P2, S1
cmovle P0, P2
mov S2, P1
cmovg S1, P2
cmp P1, P3
cmovge S2, P3
cmovg P3, P1
cmp P0, S2
mov P2, P0
cmovge P2, S2
cmovl P0, S2
cmp S1, P3
mov P2, S1
