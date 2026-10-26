# n=5 model=out iset=I1 prefix14_class=6307
cmp P2, P0
cmovge S1, P0
cmovl S1, P2
cmovge P0, P2
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
mov P2, P0
cmovge S0, P1
cmp S0, P2
cmovg P0, S0
cmovle P2, S0
cmp S1, P3
cmovl P0, P3
