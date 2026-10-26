# n=5 model=out iset=I1 prefix14_class=10977
cmp P0, P2
mov S1, P0
cmovg P0, P2
mov S0, P3
cmovge P2, S1
cmp S0, P1
cmovl P3, P1
cmovle P1, S0
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P0, P1
cmovle S1, P1
