# n=5 model=out iset=I1 prefix14_class=2125
mov S2, P2
mov S0, P1
cmp P3, P1
cmovge P1, P3
cmovl S0, P3
cmp P2, P0
cmovle P2, P0
cmovge S2, P0
mov S1, P1
cmp P1, P2
cmovl P1, P2
cmovle P2, S1
mov P1, S0
cmovge S1, P2
