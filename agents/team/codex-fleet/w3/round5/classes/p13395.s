# n=5 model=out iset=I1 prefix14_class=13395
mov S2, P0
cmp P0, P2
cmovg P0, P2
mov S1, P1
cmovge P2, S2
cmp P3, S1
cmovle S1, P3
cmovg P1, P3
mov P3, P0
cmp S1, P3
cmovl P3, S1
cmovl S1, P0
cmp P2, P1
cmovl P0, S1
