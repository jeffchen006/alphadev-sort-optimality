# n=5 model=out iset=I1 prefix14_class=13919
cmp P2, P0
cmovge S1, P2
mov S0, P1
cmovl S1, P0
cmovl P0, P2
cmp S0, P3
cmovg S0, P3
mov S2, P0
cmovle P1, P3
cmp P1, S1
cmovge P2, S1
cmovge S1, P1
cmovge P1, P2
mov P3, P1
