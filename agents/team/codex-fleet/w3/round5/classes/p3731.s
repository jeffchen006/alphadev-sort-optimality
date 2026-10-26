# n=5 model=out iset=I1 prefix14_class=3731
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovle P3, S0
mov S1, P2
cmp P0, S1
mov S2, P1
cmovg P2, P0
cmovge P0, S1
cmp P0, P3
cmovl S1, P3
cmovle P3, P0
cmovge S1, P0
mov P3, S1
