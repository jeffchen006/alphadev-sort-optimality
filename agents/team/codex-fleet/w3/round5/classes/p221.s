# n=5 model=out iset=I1 prefix14_class=221
cmp P0, P2
mov S1, P2
cmovl P2, P0
cmovge S1, P0
cmp P1, P3
cmovge S0, P1
cmovge P1, P3
cmovge P3, S0
cmp P1, P2
mov P0, P1
cmovle P1, P2
cmovle P2, P0
cmp P3, S1
cmovl P0, P1
