# n=5 model=out iset=I1 prefix14_class=9566
mov S2, P1
cmp P3, P2
cmovl S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P1, P0
cmovg S2, P0
cmovl P1, P0
cmp P1, P3
cmovl P0, P3
cmovle P3, P1
cmovge P0, P1
cmp S2, P2
mov P1, S2
