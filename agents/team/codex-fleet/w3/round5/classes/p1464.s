# n=5 model=out iset=I1 prefix14_class=1464
cmp P1, P2
mov S2, P0
cmovge S1, P2
cmovle S1, P1
cmovge P2, P1
cmp S2, P3
cmovl P0, P3
cmovle P3, S2
cmp P2, P0
cmovge P1, P2
cmovl P1, P0
cmovg P2, P0
mov P1, P2
cmp P3, S1
