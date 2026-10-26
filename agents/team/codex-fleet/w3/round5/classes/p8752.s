# n=5 model=out iset=I1 prefix14_class=8752
cmp P2, P3
cmovge S1, P3
cmovle S1, P2
cmovl P2, P3
cmp P1, P0
mov P3, P1
cmovl P3, P0
cmovl P0, P1
cmp P2, P3
cmovge P1, P2
cmovg P2, P3
cmovge P3, P1
cmp S1, P0
mov P3, S1
