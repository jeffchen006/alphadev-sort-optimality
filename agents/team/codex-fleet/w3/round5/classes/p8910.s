# n=5 model=out iset=I1 prefix14_class=8910
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
mov S0, P3
cmovg S1, P1
cmp P2, S0
cmovle S0, P2
cmovle P2, P3
mov S2, P2
cmp P2, P0
cmovl P2, P0
cmovl P0, S2
cmp S0, S1
cmovge P1, S1
