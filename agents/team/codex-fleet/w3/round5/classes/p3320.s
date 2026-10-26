# n=5 model=out iset=I1 prefix14_class=3320
mov S2, P3
cmp P2, S2
cmovg S2, P2
mov S0, P1
cmovle P3, P2
cmp P1, P0
cmovg S0, P0
mov S1, S0
cmovge P0, P1
cmp P3, S0
cmovl S1, P3
cmovl P3, S0
cmp S2, P0
mov S1, P0
