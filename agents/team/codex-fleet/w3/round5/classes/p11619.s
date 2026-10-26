# n=5 model=out iset=I1 prefix14_class=11619
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P1, P2
cmovg S0, P1
cmovge P1, P2
cmovg P2, S0
cmp P0, P2
mov S1, P0
mov S2, P1
cmovl S1, P2
cmovg P0, P2
cmp P1, P3
