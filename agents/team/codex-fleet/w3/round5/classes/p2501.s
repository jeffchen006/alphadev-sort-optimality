# n=5 model=out iset=I1 prefix14_class=2501
mov S1, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, S1
mov S0, P2
cmp P3, P2
cmovg S0, P3
mov S1, P1
cmovge P3, P2
cmp P1, S0
cmovl S1, S0
cmovl S0, P1
cmp P3, P0
cmovge P1, P3
