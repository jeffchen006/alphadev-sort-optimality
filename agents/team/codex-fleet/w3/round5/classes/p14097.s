# n=5 model=out iset=I1 prefix14_class=14097
mov S1, P1
mov S0, P2
cmp P3, S1
cmovge S1, P3
cmovge P3, P1
cmp S0, P0
cmovle S0, P0
cmovge P2, P0
cmp S1, S0
cmovl P0, S0
mov S2, P3
cmovle S0, S1
cmovl S1, P0
cmp P2, S2
