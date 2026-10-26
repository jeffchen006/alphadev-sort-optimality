# n=5 model=out iset=I1 prefix14_class=4639
mov S1, P1
mov S0, P3
cmp P2, P1
cmovge S1, P2
cmovle P1, P2
cmp P0, P3
cmovle P3, P0
cmovl P0, S0
cmp P0, S1
cmovle S2, P0
cmovg S2, S1
cmovl P0, S1
cmp P3, P1
cmovge P0, P3
