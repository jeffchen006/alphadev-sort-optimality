# n=5 model=out iset=I1 prefix14_class=2850
mov S0, P1
cmp P3, P0
mov S1, P3
cmovg S1, P0
cmovle P3, P0
cmp P1, P2
cmovge P1, P2
cmovge P2, S0
cmp P2, P3
mov S0, P3
cmovl S0, P2
cmovle P2, P3
cmp P1, S1
cmovl P3, S0
