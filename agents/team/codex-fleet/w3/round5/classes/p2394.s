# n=5 model=out iset=I1 prefix14_class=2394
cmp P0, P2
cmovge S2, P0
mov S0, P3
cmovl S2, P2
cmovge P0, P2
cmp P3, P1
mov P2, S2
cmovle P3, P1
cmovle P1, S0
cmp P2, P3
cmovle P2, P3
cmovl P3, S2
mov S2, P3
mov P2, P0
