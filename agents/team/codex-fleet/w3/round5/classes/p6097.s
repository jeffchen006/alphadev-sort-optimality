# n=5 model=out iset=I1 prefix14_class=6097
mov S2, P0
mov S0, P3
cmp S2, P1
cmovl S2, P1
cmovl P1, P0
cmp P2, S0
cmovg S0, P2
cmovge P2, P3
mov S1, S0
cmp S1, S2
cmovg S0, S2
cmovg S2, S1
mov S2, S0
cmp P2, P1
