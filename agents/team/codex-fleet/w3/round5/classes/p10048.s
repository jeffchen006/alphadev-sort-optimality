# n=5 model=out iset=I1 prefix14_class=10048
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmovle P3, S2
mov S1, P1
cmp P0, P1
cmovle P1, P0
mov S0, P2
cmovl P0, S1
cmp P0, S0
cmovge P2, P0
cmovge P0, S0
cmp P1, P3
cmovge S2, P3
