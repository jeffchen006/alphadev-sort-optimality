# n=5 model=out iset=I1 prefix14_class=7023
mov S2, P3
cmp P0, P3
mov S1, P2
cmovge S2, P0
cmovge P0, P3
cmp P2, P1
cmovl P2, P1
cmovge S1, P1
mov S0, S1
cmp P0, S0
cmovl S1, P0
cmovle P0, S0
mov S1, S2
cmp P2, S1
