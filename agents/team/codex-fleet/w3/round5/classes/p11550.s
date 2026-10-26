# n=5 model=out iset=I1 prefix14_class=11550
mov S0, P0
cmp P0, P1
cmovge P0, P1
cmovle S0, P1
cmovle P1, P0
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovge P3, S1
cmp P0, P2
cmovl P1, P2
cmovge P0, P2
cmp P3, S0
cmovge S2, P3
