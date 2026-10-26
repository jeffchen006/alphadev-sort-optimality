# n=5 model=out iset=I1 prefix14_class=4686
cmp P3, P1
mov S2, P3
cmovge S2, P1
cmovle P3, P1
cmp P2, P0
cmovge S0, P0
mov P1, P3
cmovl S0, P2
cmovle P2, P0
cmp P1, P2
cmovl P1, P2
cmovge P3, P2
mov P1, P3
cmp S2, S0
