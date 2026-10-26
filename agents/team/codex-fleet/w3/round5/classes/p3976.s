# n=5 model=out iset=I1 prefix14_class=3976
mov S1, P1
cmp S1, P3
mov S2, P0
cmovl P1, P3
cmovg S1, P3
cmp P2, P0
cmovg S2, P2
cmovl P0, P2
mov S0, S1
cmp P0, S0
cmovge S0, P0
cmovge P0, S1
cmp S2, P1
cmovle P0, P1
