# n=5 model=out iset=I1 prefix14_class=10555
mov S1, P0
mov S0, P1
cmp P2, P1
cmovle P1, P2
cmovg S0, P2
cmp P3, P0
cmovge P0, P3
cmovl S1, P3
cmp P0, S0
cmovl P3, P0
cmovle P0, S0
cmovl S0, P3
cmp P1, S1
cmovl P3, P1
