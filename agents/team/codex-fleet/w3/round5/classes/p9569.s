# n=5 model=out iset=I1 prefix14_class=9569
cmp P1, P2
cmovle S1, P1
mov S0, P3
cmovle P1, P2
cmovle P2, S1
cmp S0, P0
cmovg P3, P0
cmovge P0, S0
cmovl S0, P0
cmp P1, P0
cmovle P0, P1
cmovl P1, S0
cmovle S0, P0
mov S2, P3
