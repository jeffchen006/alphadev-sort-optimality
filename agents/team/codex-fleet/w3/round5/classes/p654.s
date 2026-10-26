# n=5 model=out iset=I1 prefix14_class=654
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovl P0, S1
mov S1, P3
cmp P3, P1
cmovl S1, P1
cmovg P3, P1
mov S0, S1
cmp S1, P0
cmovl S1, P0
cmovle P0, S0
cmp P3, P2
cmovge P1, P2
