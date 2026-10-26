# n=5 model=out iset=I1 prefix14_class=6627
mov S0, P0
cmp P1, P0
cmovge S0, P1
cmovl P0, P1
cmp P3, P2
cmovl P1, P3
cmovge P1, P2
cmovl P3, P2
mov P2, S0
cmp P3, S0
cmovg S0, P3
cmovge P3, P2
cmp P1, P0
cmovge S2, P1
