# n=5 model=out iset=I1 prefix14_class=13371
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
mov S0, P1
cmovl P3, S1
cmp P0, P1
cmovge P1, P0
cmovle S0, P0
mov S2, P3
cmp S0, P3
cmovle S2, S0
cmovge P3, S0
cmp P1, P2
cmovge S0, P2
