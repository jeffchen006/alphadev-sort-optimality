# n=5 model=out iset=I1 prefix14_class=177
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovle S1, P2
mov S0, P0
cmp P3, S0
cmovle P0, P3
cmovl P3, S0
cmovl S0, P0
cmp P1, S0
cmovge P0, P1
cmovle S0, P1
cmp S1, P3
mov S2, S1
