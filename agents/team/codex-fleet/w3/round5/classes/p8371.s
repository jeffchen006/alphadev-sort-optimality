# n=5 model=out iset=I1 prefix14_class=8371
mov S1, P1
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
cmp S1, P0
cmovge S1, P0
cmovge P0, P1
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
cmovl P0, S2
cmp S1, P2
mov S0, S1
