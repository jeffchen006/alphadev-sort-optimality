# n=5 model=out iset=I1 prefix14_class=11509
mov S2, P2
cmp P1, S2
cmovge S2, P1
cmovl P2, P1
mov S1, P0
cmp S1, P3
cmovle P0, P3
mov S0, P2
cmovge S1, P3
cmp P2, S1
cmovge P2, S1
cmovl S0, S1
cmp S2, P0
cmovge P2, P0
