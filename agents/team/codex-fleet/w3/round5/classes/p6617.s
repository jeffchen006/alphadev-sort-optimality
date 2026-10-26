# n=5 model=out iset=I1 prefix14_class=6617
mov S0, P0
cmp P2, S0
cmovle P0, P2
cmovle P2, S0
mov S1, P2
mov S2, P3
cmp S2, P1
cmovge S2, P1
cmovge P1, P3
cmp P2, P1
cmovge S1, P1
cmovl P2, P1
cmp P0, S2
cmovle P1, S1
