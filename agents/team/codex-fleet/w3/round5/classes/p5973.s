# n=5 model=out iset=I1 prefix14_class=5973
cmp P0, P3
mov S0, P3
cmovl S0, P0
cmovge P3, P0
mov S1, P1
cmp S1, P2
cmovle S1, P2
mov S2, P3
cmovg P1, P2
cmp S1, P3
cmovl P3, S1
cmovle S1, S2
cmp P1, S0
cmovle P0, P1
