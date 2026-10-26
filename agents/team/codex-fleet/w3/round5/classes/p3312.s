# n=5 model=out iset=I1 prefix14_class=3312
mov S1, P1
cmp P2, S1
cmovg S1, P2
cmovl P1, P2
cmp P3, P0
cmovl P2, P3
cmovge P2, P0
cmovg P0, P3
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmovg S0, P1
cmp P0, S1
cmovge S0, S1
