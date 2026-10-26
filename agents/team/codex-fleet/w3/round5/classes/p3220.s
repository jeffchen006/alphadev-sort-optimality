# n=5 model=out iset=I1 prefix14_class=3220
mov S1, P3
cmp P2, S1
mov S2, P0
cmovg S1, P2
cmovle P3, P2
cmp P1, S2
cmovg S2, P1
cmovg P1, P0
cmovl P0, P1
cmp P3, P1
cmovge P1, P3
cmovge P3, P0
cmp S2, S1
mov P3, S1
