# n=5 model=out iset=I1 prefix14_class=6396
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovg P1, S2
mov S1, P2
cmp P3, S1
cmovg P2, P3
cmovle S1, P3
mov P3, P2
cmp P1, P3
cmovg P2, P1
cmovl P3, P1
cmp S1, P0
mov P2, S1
