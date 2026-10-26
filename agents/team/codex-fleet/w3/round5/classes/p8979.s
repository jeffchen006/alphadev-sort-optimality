# n=5 model=out iset=I1 prefix14_class=8979
mov S2, P1
cmp P3, S2
cmovg S2, P3
cmovge P3, P1
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmovl S0, P2
cmp S2, S0
cmovle S1, S0
cmovle S0, S2
cmovl S2, S1
mov P2, P3
cmp P3, P0
