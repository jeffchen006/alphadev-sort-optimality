# n=5 model=out iset=I1 prefix14_class=5262
mov S0, P0
cmp P1, P0
cmovge S0, P1
cmovl P0, P1
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
cmovl P2, S1
cmp P3, P0
cmovge P1, P3
cmovg P3, P0
cmovle P1, P0
mov S2, P2
cmp S2, S0
