# n=5 model=out iset=I1 prefix14_class=4785
mov S1, P1
cmp S1, P3
cmovl S1, P3
cmovl P3, P1
cmp P2, P0
cmovl P1, P2
mov S0, P3
cmovge P1, P0
cmovge P0, P2
cmp P1, P3
cmovg S0, P1
cmovle P3, P1
cmp P0, S1
cmovle P2, P0
