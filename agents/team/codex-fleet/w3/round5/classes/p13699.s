# n=5 model=out iset=I1 prefix14_class=13699
mov S2, P0
cmp P0, P1
cmovg S2, P1
cmovle P0, P1
cmp P2, P3
cmovge P1, P3
cmovg P3, P2
cmovge P2, P1
cmp P2, S2
cmovl S0, P2
cmovge S0, S2
cmovg S2, P2
mov S1, P0
cmp P3, P0
