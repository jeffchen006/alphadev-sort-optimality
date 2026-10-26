# n=5 model=out iset=I1 prefix14_class=100
mov S1, P0
mov S2, P1
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
cmp P3, S2
cmovg S2, P3
cmovl P1, P3
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
cmovl P1, S0
cmp S2, P0
cmovle P2, S2
