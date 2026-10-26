# n=5 model=out iset=I1 prefix14_class=13976
cmp P3, P0
mov S0, P2
cmovg S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P1, P2
cmovg S0, P1
cmovge P1, P2
cmp P0, S0
cmovl S2, P0
mov S1, P1
cmovl P0, S0
cmovl S0, S2
cmp P1, P3
