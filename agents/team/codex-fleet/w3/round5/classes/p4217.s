# n=5 model=out iset=I1 prefix14_class=4217
mov S0, P2
mov S2, P1
cmp P0, P2
cmovge P2, P0
cmovl S0, P0
cmp P1, P3
cmovle P1, P3
cmovle P3, S2
cmp P3, S0
mov P0, S0
cmovl P0, P3
cmovg S0, P3
cmp P2, P1
cmovge S2, P2
