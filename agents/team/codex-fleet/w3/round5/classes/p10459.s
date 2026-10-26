# n=5 model=out iset=I1 prefix14_class=10459
cmp P1, P2
mov S2, P0
cmovle S1, P1
cmovl P1, P2
cmovl P2, S1
cmp P3, S2
cmovle S2, P3
cmovl P3, P0
mov P0, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, P0
cmp P2, S2
cmovge P0, S2
