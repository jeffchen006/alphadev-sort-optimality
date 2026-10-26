# n=5 model=out iset=I1 prefix14_class=9486
cmp P1, P0
mov S2, P0
cmovge S2, P1
cmovl P0, P1
cmp P2, P3
mov S1, P2
cmovge P2, P3
cmovge P3, S1
cmp P0, P2
cmovle P1, P2
cmovl P2, P0
cmovl P0, P1
cmp S2, P3
cmovge S0, P3
