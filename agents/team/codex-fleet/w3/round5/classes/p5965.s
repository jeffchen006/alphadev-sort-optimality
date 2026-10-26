# n=5 model=out iset=I1 prefix14_class=5965
cmp P1, P2
cmovge S1, P1
mov S0, P0
cmovle S1, P2
cmovle P2, P1
cmp S0, P3
cmovl S0, P3
cmovg P0, P3
cmovg P3, S0
cmp P3, S1
cmovl P3, S1
cmovg S0, S1
cmp P2, P0
cmovge P3, P2
