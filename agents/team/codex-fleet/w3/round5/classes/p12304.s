# n=5 model=out iset=I1 prefix14_class=12304
cmp P3, P2
cmovge S2, P3
cmovle S2, P2
cmovg P3, P2
cmp P1, P0
cmovge P2, P1
cmovg P1, P0
cmovle P2, P0
cmovl P0, P1
cmp P1, P3
cmovge P0, P3
cmovl P1, P3
cmp S2, P2
mov P0, S2
