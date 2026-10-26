# n=5 model=out iset=I1 prefix14_class=3637
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovle P1, S1
cmp P2, P0
mov S1, P0
cmovle P0, P2
mov S0, P1
cmovl P2, S1
cmp P0, S0
cmovl S0, P0
cmovge P1, P0
cmp P3, P2
mov P0, P3
