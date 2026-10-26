# n=5 model=out iset=I1 prefix14_class=4383
mov S2, P3
mov S1, P2
cmp P0, P2
cmovl P2, P0
cmovl P0, S1
cmovle S1, P2
cmp P1, S2
cmovle S2, P1
cmovge P3, P1
cmp P2, S2
cmovl S1, S2
cmovge P2, S2
cmp P3, P0
cmovl P2, P0
