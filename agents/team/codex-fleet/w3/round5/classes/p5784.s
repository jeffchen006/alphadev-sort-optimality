# n=5 model=out iset=I1 prefix14_class=5784
mov S1, P3
cmp P3, P2
mov S0, P0
cmovl P3, P2
cmovg S1, P2
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmovl S0, P1
cmp S0, S1
cmovl P1, S1
cmovl S1, S0
cmp P0, P3
cmovl P2, P3
