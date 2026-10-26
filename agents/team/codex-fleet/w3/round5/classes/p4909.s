# n=5 model=out iset=I1 prefix14_class=4909
cmp P1, P0
cmovge S0, P1
cmovl S0, P0
mov S2, P3
cmovle P0, P1
cmp P2, P3
mov P1, P0
cmovle P3, P2
cmovl P2, S2
cmp P0, P3
cmovge P1, P3
cmovle P0, P3
cmp P2, S0
cmovle P3, S0
