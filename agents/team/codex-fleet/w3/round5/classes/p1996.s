# n=5 model=out iset=I1 prefix14_class=1996
mov S1, P3
mov S2, P2
cmp P3, P1
cmovl S1, P1
cmovge P3, P1
cmp P0, S2
cmovle S2, P0
cmovge P2, P0
mov P0, S1
cmp S1, P2
cmovl P0, P2
cmovl P2, S1
cmp P3, S2
cmovge S1, S2
