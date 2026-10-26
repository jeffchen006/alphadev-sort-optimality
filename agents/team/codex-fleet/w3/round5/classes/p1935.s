# n=5 model=out iset=I1 prefix14_class=1935
mov S2, P2
mov S0, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, S0
cmp P3, P2
cmovl P2, P3
cmovl P3, S2
cmp P3, P1
cmovg S2, P1
cmovle S2, P3
cmovge P1, P3
cmp P0, P2
cmovge S1, P0
