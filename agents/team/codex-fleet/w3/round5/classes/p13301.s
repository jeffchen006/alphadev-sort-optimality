# n=5 model=out iset=I1 prefix14_class=13301
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovle P1, P3
mov S2, S0
cmp S0, P2
cmovg S0, P2
cmovge P2, S2
mov S0, P1
cmp P1, P0
