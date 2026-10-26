# n=5 model=out iset=I1 prefix14_class=2926
mov S1, P2
mov S0, P3
cmp P1, S0
cmovle P3, P1
cmovg S0, P1
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
cmp S0, S1
mov S2, P3
cmovl P1, S1
cmovl S1, S0
cmovl S0, P1
cmp P0, P3
