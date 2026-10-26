# n=5 model=out iset=I1 prefix14_class=7227
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovle S1, P3
cmp P0, P2
mov P3, P2
cmovge P2, P0
mov S2, S1
cmovge P0, P3
cmp P0, P1
cmovl P3, P1
cmovl P1, P0
cmovl P0, P3
cmp P2, S2
