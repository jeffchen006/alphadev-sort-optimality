# n=5 model=out iset=I1 prefix14_class=8217
cmp P2, P0
cmovle S0, P0
cmovge S0, P2
cmovge P2, P0
cmp P1, P3
mov P0, P1
cmovle P1, P3
mov S1, P1
cmovl P3, P0
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovge P2, S2
cmp S1, S0
