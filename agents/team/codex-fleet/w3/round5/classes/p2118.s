# n=5 model=out iset=I1 prefix14_class=2118
cmp P3, P0
mov S2, P0
cmovle S2, P3
cmovge P0, P3
mov P3, P1
cmp P3, P2
cmovl P3, P2
cmovg P1, P2
cmp P3, P0
cmovg P2, P3
cmovg P3, P0
cmovle P2, P0
cmp P1, S2
cmovle S0, P1
