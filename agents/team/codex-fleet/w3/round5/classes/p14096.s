# n=5 model=out iset=I1 prefix14_class=14096
mov S0, P2
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmovle S1, P1
cmp S0, P0
cmovge S0, P0
cmovl P2, P0
mov S2, P3
cmp S1, P2
cmovl P1, P2
cmovl P2, S1
cmovl S1, P1
cmp S0, P3
