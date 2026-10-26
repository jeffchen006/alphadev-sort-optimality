# n=5 model=out iset=I1 prefix14_class=12449
mov S1, P0
cmp P3, P2
cmovl S2, P3
cmovle P3, P2
cmovl P2, S2
cmp S1, P1
cmovle S1, P1
cmovge P0, P1
cmp P0, P2
cmovle P1, P0
cmovle P0, P2
mov S0, S1
cmovl P2, P1
cmp P3, S0
