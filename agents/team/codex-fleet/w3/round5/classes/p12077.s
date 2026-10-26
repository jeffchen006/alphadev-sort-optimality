# n=5 model=out iset=I1 prefix14_class=12077
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
cmovle S2, P3
mov P3, P0
cmp P2, P3
cmovle P3, P2
cmovl P2, P0
cmp S2, P3
cmovge P0, S2
cmovle P0, P3
cmovl P3, S2
cmp P2, P1
mov P3, P1
