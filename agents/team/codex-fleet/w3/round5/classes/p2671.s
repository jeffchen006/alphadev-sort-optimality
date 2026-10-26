# n=5 model=out iset=I1 prefix14_class=2671
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovge P2, P3
cmp P0, P1
mov S1, P0
cmovge S1, P1
cmovle P0, P1
mov P1, P2
cmp P2, P0
cmovg P1, P0
mov S0, P1
cmovl P2, P0
cmp S2, S1
