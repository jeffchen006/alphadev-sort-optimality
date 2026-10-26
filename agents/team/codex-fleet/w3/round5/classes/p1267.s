# n=5 model=out iset=I1 prefix14_class=1267
cmp P2, P0
cmovge S2, P2
cmovl S2, P0
cmovge P2, P0
mov S1, P1
cmp P1, P3
mov P0, S2
cmovle S1, P3
cmovl P3, P1
cmp P0, S1
cmovle S2, S1
cmovge P0, S1
cmp P2, P3
mov S1, P0
