# n=5 model=out iset=I1 prefix14_class=13015
cmp P2, P3
mov S1, P0
mov S0, P3
cmovle S0, P2
cmovge P3, P2
cmp P0, P1
cmovge P0, P1
cmovle S1, P1
cmp S0, P0
cmovl S2, S0
cmovle S0, P0
cmovl P0, S2
cmp P3, S1
cmovle P1, S1
