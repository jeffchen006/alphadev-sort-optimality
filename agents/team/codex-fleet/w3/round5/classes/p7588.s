# n=5 model=out iset=I1 prefix14_class=7588
cmp P3, P0
mov S0, P0
cmovge P0, P3
cmovl S0, P3
cmp P1, P2
mov S1, P2
cmovle S1, P1
cmovl P1, P2
cmp S0, S1
cmovl P3, S0
cmovl S0, S1
cmovl S1, P3
cmp P0, P1
cmovle P3, P1
