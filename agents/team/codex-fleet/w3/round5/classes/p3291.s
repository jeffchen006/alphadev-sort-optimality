# n=5 model=out iset=I1 prefix14_class=3291
cmp P0, P3
cmovle S1, P3
cmovg S1, P0
cmovg P0, P3
cmovl P3, P0
cmp P2, P1
cmovge S0, P1
cmovg P1, P2
cmovg P2, S0
cmp P3, P2
cmovg P0, P2
mov S2, S1
cmovge P2, P3
cmovle P3, P2
