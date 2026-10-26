# n=5 model=out iset=I1 prefix14_class=3820
mov S2, P3
cmp S2, P1
cmovge S2, P1
cmovge P1, P3
mov S0, P0
cmp P2, P0
cmovge P0, P2
cmovle S0, P2
mov P2, S2
cmp S2, S0
cmovl P2, S0
cmovle S0, S2
cmp P1, P0
cmovle S0, P0
