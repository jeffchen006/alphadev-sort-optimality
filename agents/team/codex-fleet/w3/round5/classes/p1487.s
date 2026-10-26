# n=5 model=out iset=I1 prefix14_class=1487
mov S1, P1
mov S0, P0
cmp S1, P3
cmovle S1, P3
cmovge P1, P3
cmp P0, P2
cmovl P0, P2
mov S2, P1
cmovl P2, S0
cmp S1, P0
cmovge S0, P0
cmovge P0, S1
cmovge S1, S0
cmp P2, P1
