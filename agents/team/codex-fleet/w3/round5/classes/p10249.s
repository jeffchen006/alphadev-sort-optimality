# n=5 model=out iset=I1 prefix14_class=10249
cmp P0, P1
mov S1, P0
mov S2, P3
cmovle P0, P1
cmovge S1, P1
cmp S2, P2
cmovl P3, P2
cmovl P2, S2
mov S0, P0
cmp P0, P3
cmovge P0, P3
cmovg P3, S0
cmp S1, P2
cmovge P1, S1
