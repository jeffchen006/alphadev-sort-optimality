# n=5 model=out iset=I1 prefix14_class=10201
cmp P2, P0
mov S1, P2
mov S0, P1
cmovg P2, P0
cmovg P0, S1
cmp P3, P1
cmovl S0, P3
cmovge P1, P3
cmp P0, P1
cmovl S1, P0
cmovl P0, P1
mov P0, S0
cmovl P1, S1
cmp P2, S0
