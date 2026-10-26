# n=5 model=out iset=I1 prefix14_class=12773
cmp P1, P2
mov S0, P2
mov S2, P3
cmovle S0, P1
cmovl P1, P2
cmp P0, P3
mov S1, P1
cmovge P3, P0
cmovge P0, S2
cmp S0, P0
cmovl S2, P0
cmovl P0, S0
cmovl S0, S2
mov P2, S0
