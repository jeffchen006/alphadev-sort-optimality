# n=5 model=out iset=I1 prefix14_class=6467
mov S0, P1
cmp P1, P0
mov S2, P3
cmovl P1, P0
cmovl P0, S0
cmp P2, S2
cmovle P3, P2
cmovg S2, P2
mov S1, S2
cmp S2, P1
cmovg S1, P1
cmovge P1, S2
cmp P3, P0
cmovle P2, P0
