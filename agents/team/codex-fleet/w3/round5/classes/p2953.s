# n=5 model=out iset=I1 prefix14_class=2953
cmp P2, P1
cmovge S2, P1
cmovge P1, P2
cmovle S2, P2
mov P2, P3
cmp P2, P0
cmovge P2, P0
cmovg P0, P3
cmovle P3, P0
cmp P1, P3
cmovl P0, P1
cmovle P1, P3
cmp S2, P2
cmovge S1, P2
