# n=5 model=out iset=I1 prefix14_class=10547
mov S1, P3
cmp P3, P1
mov S0, P2
cmovl P3, P1
cmovl P1, S1
cmp P0, S0
cmovg S0, P0
cmovl P2, P0
cmp S0, P3
cmovl S1, S0
cmovl S0, P3
cmovl P3, S1
cmp P2, P1
mov S0, P1
