# n=5 model=out iset=I1 prefix14_class=874
cmp P1, P2
mov S0, P1
cmovg S0, P2
mov S2, P0
cmovl P1, P2
cmp S2, P3
cmovge P0, P3
mov P2, P1
cmovge P3, S2
cmp P3, P1
cmovl P2, P3
cmovg P1, P3
cmp P0, S0
mov S2, S0
