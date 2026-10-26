# n=5 model=out iset=I1 prefix14_class=12394
cmp P1, P0
mov S0, P2
mov S2, P1
cmovl P1, P0
cmovg S2, P0
cmp P2, P3
cmovl P2, P3
cmovl P3, S0
mov S0, P3
cmp S2, S0
cmovge P3, S2
cmovle S0, S2
cmp P1, P2
cmovge S2, P1
