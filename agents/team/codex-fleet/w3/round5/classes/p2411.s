# n=5 model=out iset=I1 prefix14_class=2411
cmp P2, P0
cmovle S1, P0
cmovge S1, P2
mov S0, P3
cmovge P2, P0
mov S2, S1
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
cmp S1, S0
cmovge S1, S0
cmovle S2, S0
cmp P3, P2
cmovle P0, P2
