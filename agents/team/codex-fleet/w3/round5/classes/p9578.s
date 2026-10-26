# n=5 model=out iset=I1 prefix14_class=9578
cmp P3, P0
cmovle S0, P3
mov S2, P2
cmovle P3, P0
cmovl P0, S0
cmp P1, P2
cmovg S2, P1
cmovge P1, P2
mov S1, S2
cmp P3, S2
cmovle S1, P3
cmovge S2, P3
cmp P1, P0
cmovg S0, P1
