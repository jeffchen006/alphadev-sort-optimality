# n=5 model=out iset=I1 prefix14_class=11667
cmp P3, P0
mov S1, P3
mov S0, P1
cmovl P3, P0
cmovl P0, S1
cmp P2, S0
cmovle P1, P2
cmovl P2, S0
mov S2, P2
cmp P2, P3
cmovle S2, P3
cmovge P2, P3
cmp P1, P0
cmovge S0, P0
