# n=5 model=out iset=I1 prefix14_class=573
cmp P1, P2
mov S1, P2
cmovl S1, P1
cmovle P1, P2
cmovge P2, P1
cmp P0, P3
mov S2, S1
cmovle S0, P3
cmovge S0, P0
cmovl P3, P0
cmp S0, P1
cmovge P2, S0
cmovle P1, S0
cmp P3, S1
