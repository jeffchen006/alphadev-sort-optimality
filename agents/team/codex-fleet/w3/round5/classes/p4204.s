# n=5 model=out iset=I1 prefix14_class=4204
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovg S0, P0
mov S2, P3
cmp P3, P2
cmovl S2, P2
mov P0, P1
cmovl P2, P3
cmp P2, P1
cmovge P1, P2
cmovl P0, P2
mov P0, S0
cmp P0, S2
