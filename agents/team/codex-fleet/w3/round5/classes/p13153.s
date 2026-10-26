# n=5 model=out iset=I1 prefix14_class=13153
cmp P0, P3
mov S1, P3
cmovle S1, P0
cmovl P0, P3
mov S0, P2
cmp P2, P1
cmovg P2, P1
cmovle S0, P1
cmp S1, P2
cmovge P1, S1
cmovge S1, P2
cmovge P2, P1
cmp S0, P0
cmovge S2, S0
