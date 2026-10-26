# n=5 model=out iset=I1 prefix14_class=6861
mov S0, P2
cmp P1, P2
mov S1, P3
cmovl P2, P1
cmovl P1, S0
cmp P3, P0
cmovl S1, P0
cmovle P0, P3
mov S2, P1
cmp S1, P1
cmovge P1, S1
cmovl S2, S1
cmp P2, P0
cmovge P3, P0
