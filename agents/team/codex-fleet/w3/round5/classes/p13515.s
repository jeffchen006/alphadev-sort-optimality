# n=5 model=out iset=I1 prefix14_class=13515
mov S1, P0
mov S0, P3
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
cmp P1, S0
cmovl P3, P1
mov S2, P3
cmovg S0, P1
cmp S2, S1
cmovl S2, S1
cmovle S1, P3
cmp P2, S0
cmovle P3, S0
