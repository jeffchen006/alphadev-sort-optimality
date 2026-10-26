# n=5 model=out iset=I1 prefix14_class=5680
cmp P3, P1
mov S0, P3
cmovg S0, P1
cmovge P1, P3
mov S2, P2
cmp S2, P0
cmovg P2, P0
cmovge P0, S2
cmp P2, S0
cmovl P3, S0
cmovl S0, P2
mov S0, P1
cmovl P2, P3
cmp P0, S0
