# n=5 model=out iset=I1 prefix14_class=1179
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovle P0, S2
mov S0, P3
cmp S0, P2
cmovle S0, P2
cmovg P3, P2
cmp P1, S0
cmovle S1, S0
cmovge S1, P1
cmovge P1, S0
cmp P0, P3
mov S1, P0
