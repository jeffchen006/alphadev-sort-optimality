# n=5 model=out iset=I1 prefix14_class=257
mov S0, P1
cmp P1, P0
mov S2, P3
cmovge P1, P0
cmovge P0, S0
mov S0, P1
cmp P2, S2
cmovle P3, P2
cmovg S2, P2
cmp P3, S0
cmovle S0, P3
cmovl P3, P1
cmp P0, S2
mov S1, P3
