# n=5 model=out iset=I1 prefix14_class=7281
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovge S0, P1
mov S1, P2
cmp P0, S1
cmovle P2, P0
cmovl P0, S1
cmp P2, P3
mov S2, P2
cmovge P2, P3
cmovge P3, S2
cmp S0, P0
cmovge S2, P0
