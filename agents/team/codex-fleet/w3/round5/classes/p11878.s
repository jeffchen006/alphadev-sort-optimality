# n=5 model=out iset=I1 prefix14_class=11878
mov S1, P3
mov S2, P0
cmp P1, S1
cmovl S1, P1
cmovge P3, P1
cmp S2, P2
cmovge P0, P2
cmovle S2, P2
cmp S2, P3
cmovl P1, S2
cmovl S2, P3
cmovl P3, P1
mov S2, S1
cmp S1, P0
