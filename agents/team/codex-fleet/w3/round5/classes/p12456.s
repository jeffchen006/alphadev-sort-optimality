# n=5 model=out iset=I1 prefix14_class=12456
mov S0, P2
cmp P2, P3
mov S1, P1
cmovle S0, P3
cmovl P3, P2
cmp P1, P0
cmovl P1, P0
cmovge S1, P0
cmp P3, S1
mov S2, P3
cmovle S2, S1
cmovle S1, P3
cmp P1, S0
cmovg S1, P1
