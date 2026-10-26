# n=5 model=out iset=I1 prefix14_class=6365
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovge P0, S1
mov S0, P2
cmp P3, S0
cmovl S0, P3
cmovge P2, P3
cmp P2, P0
cmovge S2, P0
cmovle S2, P2
cmovge P0, P2
mov P2, S0
cmp P1, S0
