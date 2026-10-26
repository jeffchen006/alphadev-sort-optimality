# n=5 model=out iset=I1 prefix14_class=4930
mov S0, P3
cmp S0, P1
mov S1, P0
cmovg S0, P1
cmovl P3, P1
cmp S1, P2
cmovl P0, P2
cmovle P2, S1
cmp S0, P2
cmovge S1, S0
mov S2, P3
cmovg S0, P2
cmovge P2, S1
cmp S2, P0
