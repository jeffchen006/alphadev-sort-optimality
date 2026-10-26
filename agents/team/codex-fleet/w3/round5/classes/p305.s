# n=5 model=out iset=I1 prefix14_class=305
cmp P1, P0
mov S1, P3
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
cmp P2, P3
cmovg S1, P2
cmovl P3, P2
cmp P1, P3
mov P2, P3
cmovl P3, P1
cmovle P1, P2
cmp S1, P0
cmovl P3, P0
