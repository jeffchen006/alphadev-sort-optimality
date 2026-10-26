# n=5 model=out iset=I1 prefix14_class=11665
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
mov S0, P2
cmovl P0, S2
cmp P1, S0
cmovle P2, P1
cmovl P1, S0
mov S1, P1
cmp P1, P3
cmovle S1, P3
cmovge P1, P3
cmp P2, P0
cmovge S2, P0
