# n=5 model=out iset=I1 prefix14_class=13762
mov S1, P0
cmp P0, P2
cmovle P0, P2
mov S0, P3
cmovge S1, P2
cmp S0, P1
cmovge P3, P1
cmovge P1, S0
cmp P1, P0
cmovl S2, P1
cmovle P1, P0
cmovl P0, S2
mov P1, P3
cmp S1, P1
