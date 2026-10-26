# n=5 model=out iset=I1 prefix14_class=4303
cmp P1, P0
mov S0, P1
cmovge P1, P0
cmovl S0, P0
mov S1, S0
mov P0, P3
cmp P0, P2
cmovl P0, P2
cmovg P3, P2
cmp P1, P3
cmovl P2, P1
cmovl P1, P3
cmovl P3, P2
cmp P0, S1
