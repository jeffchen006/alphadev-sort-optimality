# n=5 model=out iset=I1 prefix14_class=11709
mov S0, P0
cmp S0, P2
cmovle S0, P2
cmovge P0, P2
cmovge P2, S0
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmovl P1, S2
cmp P3, P2
cmovge S0, P3
cmovl P2, P3
cmp P1, P0
cmovle P3, P0
