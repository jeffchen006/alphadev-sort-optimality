# n=5 model=out iset=I1 prefix14_class=1168
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P2, P1
mov S2, P2
cmovl P2, P1
cmovg S2, P1
cmp P3, P2
mov S1, P3
cmovle S1, P2
cmovge P3, P2
cmp S2, P0
cmovl P1, P0
