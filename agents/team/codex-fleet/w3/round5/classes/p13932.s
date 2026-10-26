# n=5 model=out iset=I1 prefix14_class=13932
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
mov S0, P1
cmp P0, P1
cmovge S0, P0
mov S2, P2
cmovge P0, P1
cmp P2, S0
cmovl P2, S0
cmovge S2, S0
cmp P0, P3
mov S0, P3
