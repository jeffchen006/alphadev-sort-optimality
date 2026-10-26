# n=5 model=out iset=I1 prefix14_class=4820
cmp P3, P2
cmovl S0, P2
cmovl P2, P3
cmovge S0, P3
mov P3, P0
mov S2, P2
cmp P0, P1
cmovge P0, P1
cmovge P1, P3
cmp P0, P2
cmovg S2, P0
cmovle P2, P0
cmp P1, S0
cmovle P2, S0
