# n=5 model=out iset=I1 prefix14_class=1307
cmp P0, P2
mov S0, P0
cmovg S0, P2
cmovl P0, P2
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmovl S1, P3
cmp P1, P0
mov P3, P0
cmovge P3, P1
mov P3, S0
cmovg P1, P0
cmp S0, S1
