# n=5 model=out iset=I1 prefix14_class=4082
mov S2, P2
cmp P2, P3
cmovl P2, P3
cmovle P3, S2
cmp P1, P0
cmovg S1, P0
cmovge P0, P1
cmovg P1, S1
cmp P1, P3
mov S0, P1
cmovge S0, P3
cmovl P1, P3
mov S0, P2
cmp S0, P0
