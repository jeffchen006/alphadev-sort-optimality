# n=5 model=out iset=I1 prefix14_class=8392
cmp P0, P3
cmovl S0, P0
cmovl P0, P3
mov S1, P2
cmovl P3, S0
cmp S1, P1
cmovge P2, P1
cmovge P1, S1
cmp P1, P0
cmovle S1, P1
mov S2, P2
cmovle P1, P0
cmovle P0, S1
cmp S2, P3
