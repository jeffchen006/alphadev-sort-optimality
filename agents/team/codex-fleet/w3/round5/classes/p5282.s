# n=5 model=out iset=I1 prefix14_class=5282
cmp P2, P3
mov S2, P0
cmovge S0, P2
cmovge P2, P3
cmovle S0, P3
cmp P1, S2
cmovle S2, P1
cmovl P1, P0
cmp P2, S2
mov S1, P1
cmovge P3, S2
cmovl P3, P2
cmovle P2, S2
mov P3, P2
