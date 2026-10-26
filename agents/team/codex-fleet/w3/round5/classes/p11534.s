# n=5 model=out iset=I1 prefix14_class=11534
cmp P3, P1
cmovl S2, P3
mov S1, P2
cmovle P3, P1
cmovl P1, S2
cmp P0, P2
mov S0, P1
cmovle S1, P0
cmovle P0, P2
cmp P1, S1
cmovg S0, S1
cmovg S1, P1
cmp P3, P0
cmovge S0, P0
