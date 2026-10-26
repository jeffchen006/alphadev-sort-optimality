# n=5 model=out iset=I1 prefix14_class=5600
mov S1, P3
cmp S1, P0
cmovge P3, P0
cmovl S1, P0
cmovle P0, P3
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmovl P1, S0
cmp P0, P1
cmovg P3, P1
cmovg P1, P0
cmp P2, S1
cmovle P3, P2
