# n=5 model=out iset=I1 prefix14_class=4203
cmp P1, P2
cmovle S2, P2
cmovl P2, P1
cmovg S2, P1
cmp P0, P3
mov S1, P2
mov S0, P0
cmovle S0, P3
cmovle P3, P0
cmp P3, S1
cmovl S1, P3
mov S1, S2
cmovge P2, P3
cmp S1, S0
