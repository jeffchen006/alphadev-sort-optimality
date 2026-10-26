# n=5 model=out iset=I1 prefix14_class=2577
mov S0, P3
cmp S0, P0
cmovg S0, P0
cmovl P3, P0
mov S1, P1
cmp P2, P1
cmovg S1, P2
cmovge P2, P1
cmp P3, S1
cmovle P0, S1
cmovg P0, P3
cmovg P3, S1
cmp P2, S0
cmovge S2, P2
