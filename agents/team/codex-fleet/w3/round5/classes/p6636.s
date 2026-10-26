# n=5 model=out iset=I1 prefix14_class=6636
mov S1, P2
mov S0, P3
cmp P0, P2
cmovge S1, P0
cmovl P2, P0
cmp S0, P1
cmovl S0, P1
cmovle P1, P3
cmp S1, S0
cmovge S2, S1
mov P3, P1
cmovg S1, S0
cmovge S0, S2
cmp P2, P1
