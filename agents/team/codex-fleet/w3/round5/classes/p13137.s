# n=5 model=out iset=I1 prefix14_class=13137
mov S1, P2
cmp S1, P0
cmovle P2, P0
cmovge S1, P0
cmp P1, P3
cmovl P0, P1
cmovl P1, P3
cmovl P3, P0
mov S0, S1
cmp S0, P3
cmovge S1, P3
cmovge P3, S0
cmp P1, P2
cmovl P0, P2
