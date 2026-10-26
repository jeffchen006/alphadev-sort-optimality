# n=5 model=out iset=I1 prefix14_class=924
mov S2, P1
cmp P2, S2
cmovl P1, P2
cmovge S2, P2
mov S0, P0
cmp S0, P3
cmovg S0, P3
cmovge P3, P0
mov P0, S2
cmp P3, P0
mov S1, S0
cmovg S2, P3
cmovl P0, P3
cmovge P3, P0
