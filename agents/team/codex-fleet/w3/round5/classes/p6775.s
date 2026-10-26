# n=5 model=out iset=I1 prefix14_class=6775
mov S1, P1
mov S2, P3
cmp P1, P2
cmovl P1, P2
cmovg S1, P2
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
mov P3, S2
cmp S2, P1
cmovg S2, P1
cmovge P1, P3
cmp S1, P0
cmovle P1, P0
