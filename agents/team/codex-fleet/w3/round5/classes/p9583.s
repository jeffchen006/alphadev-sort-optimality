# n=5 model=out iset=I1 prefix14_class=9583
cmp P2, P3
cmovle S2, P2
mov S0, P1
cmovl P2, P3
cmovl P3, S2
cmp P0, P1
cmovge S0, P0
cmovge P0, P1
cmp S0, P2
cmovge P1, P2
cmovle P1, S0
cmovge P2, S0
cmp P3, P0
cmovle S2, P0
