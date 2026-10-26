# n=5 model=out iset=I1 prefix14_class=9803
cmp P2, P1
cmovge S2, P2
cmovle S2, P1
cmovge P2, P1
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmovge S1, P3
mov P3, P0
cmp S2, P0
cmovl P3, S2
cmovge P0, S2
cmp P2, S1
cmovge S2, P3
