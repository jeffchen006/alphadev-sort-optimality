# n=5 model=out iset=I1 prefix14_class=9200
mov S2, P1
mov S0, P0
cmp P3, P1
cmovg S2, P3
cmovg P3, P1
cmp P2, P0
cmovl P0, P2
cmovge S0, P2
cmp P3, P0
cmovg P1, P0
cmovge P0, P3
mov S1, S0
cmovg P3, P1
cmp S1, S2
