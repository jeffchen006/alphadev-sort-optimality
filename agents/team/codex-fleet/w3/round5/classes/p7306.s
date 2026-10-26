# n=5 model=out iset=I1 prefix14_class=7306
cmp P0, P1
cmovl S0, P1
cmovle P1, P0
cmovl P0, S0
mov S1, P2
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
cmp P1, S1
cmovge P2, P1
cmovge P1, S1
mov P1, P3
cmovge S1, P2
mov S0, S1
