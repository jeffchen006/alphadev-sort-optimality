# n=5 model=out iset=I1 prefix14_class=2078
mov S2, P3
cmp P1, P3
cmovge P3, P1
cmovle S2, P1
cmp P2, P0
mov P1, P2
cmovg P2, P0
cmovle P1, P0
cmovg P0, P1
cmp P0, P3
cmovl P1, P3
cmovg P0, P3
cmp P2, S2
cmovge P3, S2
