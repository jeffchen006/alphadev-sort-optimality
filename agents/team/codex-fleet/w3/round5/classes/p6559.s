# n=5 model=out iset=I1 prefix14_class=6559
cmp P0, P2
mov S1, P0
cmovge P0, P2
cmovl S1, P2
cmp P1, P3
cmovle P2, P1
cmovl P1, P3
cmovle P3, P2
mov S2, S1
mov S0, P3
cmp P1, S1
cmovle S1, P1
cmovle P1, S2
cmp S0, P0
