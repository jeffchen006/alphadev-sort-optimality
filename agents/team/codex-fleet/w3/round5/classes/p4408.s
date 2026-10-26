# n=5 model=out iset=I1 prefix14_class=4408
cmp P3, P1
cmovge S1, P3
mov S0, P0
cmovg P3, P1
cmovl S1, P1
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
mov P1, P2
cmp S1, P2
cmovle P1, S1
cmovl S1, P2
cmovl P2, P1
mov S1, S0
