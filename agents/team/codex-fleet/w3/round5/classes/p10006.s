# n=5 model=out iset=I1 prefix14_class=10006
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovle P2, P1
mov S1, S0
cmp P0, P3
mov S2, P0
cmovge S2, P3
cmovge P3, P0
cmp S1, P3
cmovl S1, P3
cmovl P3, S0
cmovge S0, P3
mov S1, S2
