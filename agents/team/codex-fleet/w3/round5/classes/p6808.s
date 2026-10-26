# n=5 model=out iset=I1 prefix14_class=6808
cmp P2, P3
mov S0, P3
cmovge S0, P2
cmovl P3, P2
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovl S2, P1
cmp S0, S2
mov S1, S0
cmovle S1, S2
cmovle S2, S0
cmp P0, P3
mov S1, S2
