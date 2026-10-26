# n=5 model=out iset=I1 prefix14_class=2409
cmp P2, P0
mov S1, P0
mov S2, P3
cmovge S1, P2
cmovge P2, P0
cmp P1, P3
cmovg S2, P1
cmovle P3, P1
cmp S1, S2
mov P1, S1
cmovg S1, S2
cmovl P1, S2
cmp P3, P2
cmovl P0, P2
