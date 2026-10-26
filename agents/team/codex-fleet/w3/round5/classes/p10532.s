# n=5 model=out iset=I1 prefix14_class=10532
cmp P1, P3
mov S1, P2
mov S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P0, S1
mov S2, P3
cmovge P2, P0
cmovge P0, S1
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmovl P2, S1
cmp P0, S2
