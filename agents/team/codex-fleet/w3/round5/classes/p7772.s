# n=5 model=out iset=I1 prefix14_class=7772
mov S0, P2
cmp P2, P3
cmovge S0, P3
mov S1, P0
cmovl P2, P3
cmp P0, P1
cmovl S1, P1
cmovg P0, P1
cmp P0, S0
cmovg P3, S0
cmovge S0, P0
cmovg P0, P3
mov P0, S1
cmp P0, P2
