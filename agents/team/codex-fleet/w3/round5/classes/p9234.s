# n=5 model=out iset=I1 prefix14_class=9234
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
mov S1, P1
cmovge P2, S2
cmp P0, P1
cmovge P1, P0
cmovle S1, P0
mov S0, P2
cmp S0, S1
cmovl S0, S1
mov P0, S0
cmovl S1, P2
cmp P1, P3
