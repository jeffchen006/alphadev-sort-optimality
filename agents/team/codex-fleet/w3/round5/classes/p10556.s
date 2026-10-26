# n=5 model=out iset=I1 prefix14_class=10556
mov S0, P1
cmp P2, S0
cmovl P1, P2
cmovg S0, P2
mov S1, P0
cmp P3, P0
cmovge P0, P3
cmovl S1, P3
cmp P0, S0
mov S2, P0
cmovle P0, S0
cmovl S0, S2
mov P0, S0
cmp P1, S1
