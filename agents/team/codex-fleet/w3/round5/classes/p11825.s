# n=5 model=out iset=I1 prefix14_class=11825
cmp P3, P1
cmovl S0, P1
cmovle P1, P3
mov S2, P2
cmovl P3, S0
cmp P0, S2
cmovge S2, P0
cmovle P2, P0
cmp P3, S2
cmovge S1, P3
cmovge P3, S2
cmovl S1, S2
cmp P2, P1
mov S1, P1
