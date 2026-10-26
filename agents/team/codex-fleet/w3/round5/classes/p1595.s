# n=5 model=out iset=I1 prefix14_class=1595
mov S1, P2
cmp S1, P1
cmovge S1, P1
mov S2, P0
cmovge P1, P2
cmp P3, S2
cmovl P0, P3
cmovg S2, P3
mov P2, S1
cmp P2, P0
cmovle S1, P0
cmovge P2, P0
cmp S2, P1
mov P3, S1
