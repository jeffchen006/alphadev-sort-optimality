# n=5 model=out iset=I1 prefix14_class=11289
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovle P1, P2
cmp P0, P3
cmovge P2, P0
cmovle P2, P3
cmovge P0, P3
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmovl P1, S2
cmp P0, S0
mov P3, S0
