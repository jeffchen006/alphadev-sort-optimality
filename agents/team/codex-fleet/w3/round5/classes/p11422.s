# n=5 model=out iset=I1 prefix14_class=11422
cmp P1, P0
mov S1, P1
mov S0, P2
cmovl P1, P0
cmovg S1, P0
cmp S0, P3
cmovge P2, P3
cmovge P3, S0
mov S2, S1
cmp S1, P2
cmovl S2, P2
cmovle P2, S1
cmp P1, P3
cmovge S1, P3
