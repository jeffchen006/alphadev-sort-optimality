# n=5 model=out iset=I1 prefix14_class=13626
cmp P2, P0
cmovge S2, P2
cmovle S2, P0
cmovl P0, P2
cmp P3, P1
mov S1, P1
cmovge S1, P3
cmovge P3, P1
cmp P0, P3
cmovge P2, P3
cmovg P3, P0
cmovge P0, P2
cmp S2, S1
mov P0, S1
