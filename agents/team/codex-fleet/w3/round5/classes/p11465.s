# n=5 model=out iset=I1 prefix14_class=11465
mov S0, P3
cmp S0, P0
cmovge P3, P0
cmovle S0, P0
mov S1, S0
cmp P2, P1
mov S2, P3
cmovle P0, P2
cmovle P2, P1
cmovl P1, P0
cmp P1, P3
cmovl S2, P1
cmovl P1, P3
cmp P2, S1
