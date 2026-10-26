# n=5 model=out iset=I1 prefix14_class=10376
mov S1, P2
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
cmp P2, P1
cmovl P2, P1
cmovg S1, P1
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmovge P2, S0
cmp P3, S1
cmovge S2, P3
