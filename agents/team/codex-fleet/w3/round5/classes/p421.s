# n=5 model=out iset=I1 prefix14_class=421
mov S1, P3
cmp P1, P3
cmovg S1, P1
cmovl P3, P1
mov S0, P2
cmp S0, P0
cmovg S0, P0
cmovge P0, P2
mov P2, S0
cmp P3, S0
cmovl P2, P3
cmovl P3, S0
cmp S1, P0
cmovge S0, P0
