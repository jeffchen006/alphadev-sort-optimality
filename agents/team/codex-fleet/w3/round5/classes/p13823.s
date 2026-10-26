# n=5 model=out iset=I1 prefix14_class=13823
cmp P2, P0
mov S0, P1
cmovl S2, P0
cmovge S2, P2
cmovge P2, P0
cmp P3, S0
cmovle S0, P3
cmovge P1, P3
cmp P1, S2
cmovle S1, P1
cmovge S1, S2
cmovge S2, P1
cmp S0, P2
cmovle S2, P2
