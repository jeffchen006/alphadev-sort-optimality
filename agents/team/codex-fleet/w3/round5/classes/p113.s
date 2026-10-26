# n=5 model=out iset=I1 prefix14_class=113
cmp P2, P3
cmovge S2, P2
cmovl S2, P3
cmovge P2, P3
mov S0, P0
cmp P1, P0
cmovge S0, P1
cmovle P0, P1
cmp P0, P2
cmovl P3, P2
cmovle P2, P0
cmovl P0, P3
mov P2, S0
mov S1, P0
