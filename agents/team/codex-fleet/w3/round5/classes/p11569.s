# n=5 model=out iset=I1 prefix14_class=11569
cmp P2, P1
mov S1, P2
cmovge S1, P1
cmovge P1, P2
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovl P0, P3
cmp S1, S0
mov P2, S0
cmovle P2, S1
cmovl S1, S0
cmp P1, P0
cmovge S0, S1
