# n=5 model=out iset=I1 prefix14_class=9136
cmp P3, P0
mov S1, P3
cmovl S1, P0
cmovl P0, P3
cmp P2, P1
cmovge P3, P1
cmovge P1, P2
mov S0, P0
cmovg P2, P3
cmp P2, S0
cmovle P0, P2
cmovl P2, S0
cmp S1, P1
cmovle S0, P1
