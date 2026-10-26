# n=5 model=out iset=I1 prefix14_class=6019
mov S0, P0
cmp P2, S0
cmovl P0, P2
cmovl P2, S0
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
mov S2, P2
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmp P0, P1
cmovge P3, P1
