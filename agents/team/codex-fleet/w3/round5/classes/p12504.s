# n=5 model=out iset=I1 prefix14_class=12504
mov S0, P0
cmp P0, P3
cmovle P0, P3
cmovle P3, S0
mov S1, P1
cmp P2, P1
cmovl S1, P2
cmovge P1, P2
cmp S1, P3
cmovl S0, S1
cmovl S1, P3
cmovl P3, S0
mov P3, S1
mov P2, P0
