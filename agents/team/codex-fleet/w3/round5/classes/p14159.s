# n=5 model=out iset=I1 prefix14_class=14159
cmp P1, P3
mov S2, P3
cmovle P3, P1
cmovl P1, S2
mov S1, P2
cmp P0, P2
mov S0, P1
cmovg S1, P0
cmovge P0, P2
cmp S0, S1
cmovge P1, S1
cmovg S1, S0
cmp P0, P3
cmovge S0, P0
