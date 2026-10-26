# n=5 model=out iset=I1 prefix14_class=7740
cmp P1, P2
mov S1, P0
mov S2, P2
cmovg S2, P1
cmovle P2, P1
cmp S1, P3
cmovge S1, P3
cmovl P0, P3
cmp P2, S1
mov P1, S1
cmovl P1, P2
cmovle P2, S1
cmp S2, P0
cmovge P1, S2
