# n=5 model=out iset=I1 prefix14_class=12108
cmp P3, P0
mov S2, P2
cmovle S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P1, P2
cmovle S2, P1
mov S1, S2
cmovle P1, P2
cmovge P2, P1
cmp S1, P0
cmovg S2, P0
cmovl S1, P0
mov S2, S1
