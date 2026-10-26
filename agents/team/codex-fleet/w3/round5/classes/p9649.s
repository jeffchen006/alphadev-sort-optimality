# n=5 model=out iset=I1 prefix14_class=9649
mov S0, P0
cmp P1, S0
cmovl P0, P1
cmovge S0, P1
mov P1, P3
cmp P1, P2
mov S1, S0
cmovg P3, P2
cmovl P1, P2
cmp P1, S1
cmovl S1, P1
cmovge S0, P1
cmp P0, P3
cmovge P1, P3
