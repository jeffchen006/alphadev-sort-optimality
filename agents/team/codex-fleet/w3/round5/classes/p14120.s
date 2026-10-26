# n=5 model=out iset=I1 prefix14_class=14120
cmp P2, P0
mov S1, P2
mov S2, P1
cmovg S1, P0
cmovge P0, P2
cmp P3, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P3
cmovl S0, P0
cmovl P0, P3
cmovl P3, S0
mov P0, P1
cmp S1, P0
