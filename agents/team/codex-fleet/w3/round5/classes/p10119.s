# n=5 model=out iset=I1 prefix14_class=10119
mov S1, P3
cmp P0, P2
cmovle S2, P2
cmovge S2, P0
mov S0, S2
cmovge P0, P2
cmp P3, P1
cmovg S1, P1
cmovle P3, P1
cmp P3, S2
cmovle S0, P3
cmovl P3, S2
cmp P0, S1
cmovle P1, S1
