# n=5 model=out iset=I1 prefix14_class=10518
cmp P3, P2
mov S0, P0
mov S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmp P0, P3
cmovle P2, P3
cmovl P3, P0
cmovl P0, P2
mov P0, P3
cmp P1, S2
