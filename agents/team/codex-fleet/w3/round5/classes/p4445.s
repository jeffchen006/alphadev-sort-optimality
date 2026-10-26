# n=5 model=out iset=I1 prefix14_class=4445
cmp P3, P1
mov S1, P1
cmovge P1, P3
cmovge P3, S1
mov S0, P0
cmp P0, P2
cmovle S0, P2
mov S2, S0
cmovl P2, P0
cmp S0, P1
cmovl S0, P1
cmovl P1, S2
mov S0, P1
mov S2, P3
