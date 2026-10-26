# n=5 model=out iset=I1 prefix14_class=9134
mov S0, P3
cmp P3, P2
cmovle S0, P2
cmovle P2, P3
cmp P0, P1
cmovl S2, P1
cmovge S2, P0
mov S1, P2
cmovge P0, P1
cmp P0, S1
cmovle P2, P0
cmovl P0, S1
cmp S2, S0
cmovle S1, S0
