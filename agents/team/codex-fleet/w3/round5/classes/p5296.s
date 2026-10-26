# n=5 model=out iset=I1 prefix14_class=5296
cmp P1, P2
mov S2, P1
mov S1, P0
cmovge P1, P2
cmovg P2, S2
cmp P0, P3
cmovg S1, P3
mov S2, S1
cmovle P0, P3
cmp S1, P1
cmovl S2, P1
cmovl P1, S1
mov P1, S2
cmp P0, P2
