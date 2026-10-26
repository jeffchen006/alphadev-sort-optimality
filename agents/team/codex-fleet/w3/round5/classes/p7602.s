# n=5 model=out iset=I1 prefix14_class=7602
cmp P2, P0
cmovl S1, P2
cmovl P2, P0
mov S0, P3
cmovl P0, S1
cmp P1, S0
cmovge P3, P1
cmovge P1, S0
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovge S0, P0
mov P0, P2
mov P1, S0
