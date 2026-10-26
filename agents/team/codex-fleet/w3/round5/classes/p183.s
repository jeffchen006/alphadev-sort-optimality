# n=5 model=out iset=I1 prefix14_class=183
mov S1, P3
mov S0, P1
cmp P1, P0
cmovle S0, P0
cmovge P1, P0
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P1, S1
mov S2, P2
cmovle S1, P1
cmovge P3, P1
mov P0, P3
