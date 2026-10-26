# n=5 model=out iset=I1 prefix14_class=9663
mov S2, P2
mov S1, P1
cmp P2, P0
cmovge S2, P0
cmovle P2, P0
cmp P1, P3
cmovle P1, P3
mov S0, P1
cmovl P3, S1
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
cmp S2, P3
cmovl S1, P3
