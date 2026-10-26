# n=5 model=out iset=I1 prefix14_class=8604
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
cmovle P1, S0
mov S2, P3
cmp P3, P0
cmovg S2, P0
cmovle P3, P0
mov S1, S2
cmovge P0, P3
cmp P3, P1
cmovl P0, P1
cmovl P1, P3
cmp S1, P2
