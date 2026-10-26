# n=5 model=out iset=I1 prefix14_class=11490
mov S2, P1
cmp P1, P0
mov S0, P3
cmovle P1, P0
cmovle P0, S2
cmp S0, P2
cmovl S0, P2
cmovg P3, P2
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
cmovl P3, S2
cmp P1, S0
cmovge P3, P1
