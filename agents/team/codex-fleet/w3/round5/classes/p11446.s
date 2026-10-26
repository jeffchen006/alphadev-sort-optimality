# n=5 model=out iset=I1 prefix14_class=11446
mov S1, P3
mov S2, P0
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmp P2, S2
cmovge S2, P2
cmovge P2, P0
mov S0, P1
cmp P2, S0
cmovge P1, P2
cmovge P2, S0
mov S0, S2
mov P2, P1
