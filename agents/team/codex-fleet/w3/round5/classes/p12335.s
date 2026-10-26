# n=5 model=out iset=I1 prefix14_class=12335
cmp P2, P3
mov S0, P2
cmovge S0, P3
cmovl P2, P3
cmp P0, P1
mov S1, P1
cmovge S1, P0
cmovge P0, P1
cmp P0, S0
cmovle P1, S0
cmovle S0, P0
cmovl P0, P1
cmp P2, S1
cmovge P1, P2
