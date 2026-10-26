# n=5 model=out iset=I1 prefix14_class=13138
mov S0, P2
cmp S0, P0
cmovle P2, P0
cmovge S0, P0
cmp P1, P3
mov S2, S0
cmovle P0, P1
cmovl P1, P3
cmovle P3, P0
cmp S0, P3
cmovg S2, P3
cmovge P3, S0
cmp P1, P2
cmovge P0, P1
