# n=5 model=out iset=I1 prefix14_class=12889
mov S0, P3
cmp P3, P1
cmovge P3, P1
cmovle S0, P1
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovl P2, S2
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
cmp S0, P2
cmovl P1, S0
