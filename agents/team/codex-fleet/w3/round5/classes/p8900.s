# n=5 model=out iset=I1 prefix14_class=8900
mov S0, P3
cmp S0, P0
cmovl S0, P0
mov S1, P1
cmovge P3, P0
cmp S1, P2
cmovge P1, P2
cmovle S1, P2
cmp S1, S0
cmovl S2, S1
mov P2, P3
cmovl S1, S0
cmovl S0, S2
cmp P1, P2
