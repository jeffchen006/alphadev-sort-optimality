# n=5 model=out iset=I1 prefix14_class=4723
mov S1, P2
cmp P2, P3
cmovl P2, P3
cmovge S1, P3
cmp P1, P0
mov P3, P0
cmovge P0, P1
cmovge P1, P3
mov S0, P1
cmp S1, P1
cmovge S0, S1
cmovge S1, P1
mov P1, P0
mov S1, S0
