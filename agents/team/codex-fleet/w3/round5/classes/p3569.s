# n=5 model=out iset=I1 prefix14_class=3569
cmp P2, P1
mov S0, P3
cmovle S2, P2
cmovl P2, P1
cmovle P1, S2
cmp P0, P3
cmovle S0, P0
cmovge P3, P0
mov S1, S0
cmp S0, P1
cmovge S1, P1
cmovge P1, S0
mov S0, P3
cmp P2, P3
