# n=5 model=out iset=I1 prefix14_class=14405
mov S1, P1
mov S2, P2
cmp P3, S2
cmovl P2, P3
cmovl P3, S2
cmp S1, P0
cmovg S1, P0
cmovg P0, P1
cmp S1, P2
cmovge S2, S1
cmovge S1, P2
cmovge P2, S2
mov S0, P3
mov S1, P2
