# n=5 model=out iset=I1 prefix14_class=592
cmp P0, P1
cmovle S2, P0
mov S1, P2
cmovg S2, P1
cmovl P0, P1
cmovge P1, P0
cmp P2, P3
cmovge S1, P3
cmovge P3, P2
cmp P3, P1
cmovl P1, P3
cmovg P0, P3
cmp S2, S1
mov P2, S2
