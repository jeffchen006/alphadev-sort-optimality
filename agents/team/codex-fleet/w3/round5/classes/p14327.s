# n=5 model=out iset=I1 prefix14_class=14327
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P3, P1
mov S0, P3
cmovle S0, P1
cmovge P3, P1
mov S1, P2
cmp S1, P3
cmovle P2, P3
cmovge S1, P3
cmp P0, S0
cmovge P1, P0
