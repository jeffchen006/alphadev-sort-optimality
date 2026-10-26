# n=5 model=out iset=I1 prefix14_class=1159
cmp P3, P0
mov S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovge S2, P1
mov S1, P2
cmp P2, P3
cmovle S1, P3
cmovge P2, P3
mov S1, P0
cmovl P3, P2
