# n=5 model=out iset=I1 prefix14_class=7898
mov S1, P3
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmp P0, P2
mov S2, S1
mov S0, P0
cmovl P0, P2
cmovg S0, P2
cmp S0, S2
cmovg S2, S0
cmovl S1, S0
mov S1, S2
mov S0, P1
