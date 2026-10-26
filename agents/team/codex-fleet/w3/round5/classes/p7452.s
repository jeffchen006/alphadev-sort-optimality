# n=5 model=out iset=I1 prefix14_class=7452
cmp P3, P1
cmovge S2, P3
mov S1, P0
cmovg P3, P1
cmovge P1, S2
cmp S1, P2
cmovle S1, P2
cmovge P0, P2
cmovl P2, P0
cmp P3, P2
cmovl P2, P3
cmovg P0, P3
cmp S1, P1
mov P2, S1
