# n=5 model=out iset=I1 prefix14_class=5105
mov S1, P0
cmp S1, P2
cmovge P0, P2
cmovl S1, P2
mov S0, P3
cmp S0, P1
cmovge S0, P1
cmovle P3, P1
mov S2, S0
cmp P0, S0
cmovle S0, P0
cmovl P0, S2
cmovg S2, P0
cmp P3, S1
