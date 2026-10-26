# n=5 model=out iset=I1 prefix14_class=1147
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovl P1, S0
mov S0, P2
cmp S0, P0
cmovge P2, P0
cmovle S0, P0
cmp S0, P3
cmovge S1, S0
cmovl S1, P3
cmovl P3, S0
cmp P2, P1
cmovge P0, P1
