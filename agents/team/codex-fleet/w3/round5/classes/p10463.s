# n=5 model=out iset=I1 prefix14_class=10463
cmp P0, P3
cmovge S1, P3
cmovle S1, P0
cmovg P3, P0
cmp P2, P1
cmovle P0, P2
cmovle P2, P1
mov S2, P3
cmovl P1, P0
cmp S2, P2
cmovg S2, P2
cmovge P2, P3
cmp S1, P1
cmovge P0, P1
