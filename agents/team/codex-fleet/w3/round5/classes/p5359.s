# n=5 model=out iset=I1 prefix14_class=5359
cmp P0, P1
mov S1, P0
cmovl P0, P1
mov S2, P2
cmovge S1, P1
cmp P3, P2
cmovg P2, P3
cmovle S2, P3
mov P3, S2
cmp S1, S2
cmovle S2, S1
cmovge P3, S1
cmp P0, P2
cmovge P1, P0
