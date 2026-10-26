# n=5 model=out iset=I1 prefix14_class=13542
mov S1, P3
mov S2, P0
cmp S1, P2
cmovle S1, P2
cmovge P3, P2
cmp P1, S2
cmovl P0, P1
cmovle P1, S2
cmp P0, P3
cmovle P2, P3
cmovle P3, P0
cmovl P0, P2
cmp S1, P1
cmovg S0, P1
