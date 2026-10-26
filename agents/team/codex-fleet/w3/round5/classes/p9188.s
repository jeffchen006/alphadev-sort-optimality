# n=5 model=out iset=I1 prefix14_class=9188
cmp P3, P2
cmovle S0, P2
cmovle P2, P3
cmovge S0, P3
cmp P1, P0
mov S2, P1
mov S1, P2
cmovl P1, P0
cmovge S2, P0
cmp S1, S2
cmovge P2, S2
cmovle S1, S2
cmp P1, S0
cmovle S2, S0
