# n=5 model=out iset=I1 prefix14_class=8394
mov S1, P1
cmp S1, P0
cmovle S1, P0
cmovl P0, P1
mov P1, P3
cmp P3, P2
cmovl P1, P2
cmovge P3, P2
cmovg P2, P1
cmp P1, S1
cmovge P2, S1
cmovl P1, S1
cmp P0, P3
cmovle S2, P3
