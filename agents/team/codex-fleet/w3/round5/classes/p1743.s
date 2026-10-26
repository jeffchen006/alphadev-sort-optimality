# n=5 model=out iset=I1 prefix14_class=1743
mov S1, P2
cmp S1, P1
cmovl S1, P1
cmovl P1, P2
mov S0, P0
cmp S0, P3
cmovge S0, P3
cmovl P0, P3
cmp S0, P1
cmovle P3, S0
cmovle S0, P1
cmovge P3, P1
cmovge P1, S0
cmp P0, S1
