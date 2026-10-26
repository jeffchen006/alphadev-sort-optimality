# n=5 model=out iset=I1 prefix14_class=3087
cmp P2, P3
cmovle S1, P3
mov S2, P0
cmovge S1, P2
cmovge P2, P3
cmp P1, S2
cmovle P0, P1
cmovl P1, S2
cmp P2, P0
mov P3, P2
cmovl P2, P0
cmovge P3, P0
cmp P1, S1
cmovle S0, S1
