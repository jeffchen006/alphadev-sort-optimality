# n=5 model=out iset=I1 prefix14_class=6018
mov S0, P0
cmp P2, S0
cmovl P0, P2
cmovle P2, S0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
mov S2, P2
cmp P2, P1
cmovge S2, P1
cmovge P1, P2
cmp P0, P3
cmovge P1, P3
