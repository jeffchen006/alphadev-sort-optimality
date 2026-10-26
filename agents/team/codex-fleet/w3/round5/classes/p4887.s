# n=5 model=out iset=I1 prefix14_class=4887
mov S2, P3
cmp P0, S2
cmovl P3, P0
cmovle P0, S2
cmp P1, P2
cmovg S1, P2
cmovle S1, P1
mov S0, P3
cmovle P1, P2
cmp P3, S1
cmovge P3, S1
cmovle S0, S1
cmp P1, P0
cmovge S2, P1
