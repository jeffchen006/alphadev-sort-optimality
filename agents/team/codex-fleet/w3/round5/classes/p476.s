# n=5 model=out iset=I1 prefix14_class=476
cmp P2, P0
cmovle S1, P0
cmovg S1, P2
mov S2, S1
cmovl P0, P2
mov S0, P1
cmp S0, P3
cmovg P1, P3
cmovge P3, S0
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
cmp S2, P3
