# n=5 model=out iset=I1 prefix14_class=13513
cmp P0, P2
mov S0, P2
cmovl P2, P0
mov S2, P2
cmovl P0, S0
cmp P1, P3
mov S1, P3
cmovge S1, P1
cmovle P3, P1
cmp S2, P3
cmovl S2, P3
cmovl P3, P2
cmp S1, P0
cmovge S0, P0
