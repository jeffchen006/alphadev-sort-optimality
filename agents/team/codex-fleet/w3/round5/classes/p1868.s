# n=5 model=out iset=I1 prefix14_class=1868
mov S2, P3
cmp P1, P3
mov S1, P0
cmovl S2, P1
cmovle P1, P3
cmovg P3, P1
cmp P2, S1
cmovl S1, P2
cmovge P0, P2
cmp P0, P3
cmovle P1, P0
cmovl P0, P3
cmp S1, S2
cmovle S0, S1
