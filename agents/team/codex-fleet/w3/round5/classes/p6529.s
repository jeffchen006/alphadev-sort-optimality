# n=5 model=out iset=I1 prefix14_class=6529
mov S1, P1
cmp P1, P2
cmovge P1, P2
cmovg P2, S1
mov S0, P0
cmp P3, S0
cmovl S0, P3
cmovle P3, P0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
mov S1, P1
cmp S0, S1
