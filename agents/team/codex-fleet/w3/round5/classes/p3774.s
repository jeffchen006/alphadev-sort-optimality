# n=5 model=out iset=I1 prefix14_class=3774
mov S1, P0
cmp P2, P0
cmovge P0, P2
cmovle S1, P2
mov S2, P3
cmp P1, P3
cmovge P3, P1
cmovg P1, S2
cmp S1, P1
mov P2, S1
cmovl S1, P1
cmovl P1, P2
cmp P0, P3
cmovge P1, P0
