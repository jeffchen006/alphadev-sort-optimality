# n=5 model=out iset=I1 prefix14_class=13764
mov S1, P0
cmp P0, P2
cmovle P0, P2
cmovge S1, P2
mov S0, P3
cmp P3, P1
cmovge S0, P1
cmovge P1, P3
cmp P1, P0
cmovl P2, P1
cmovle P1, P0
cmovl P0, P2
mov P1, S1
cmp S0, P1
