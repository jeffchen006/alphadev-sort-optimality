# n=5 model=out iset=I1 prefix14_class=3873
mov S0, P1
cmp P1, P2
cmovge S0, P2
mov S1, P3
mov S2, S0
cmovge P2, P1
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmp S2, P0
cmovl S0, P0
cmovle P0, S2
cmp P2, S1
cmovl P3, S1
