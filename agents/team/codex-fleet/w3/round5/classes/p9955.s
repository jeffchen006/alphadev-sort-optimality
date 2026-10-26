# n=5 model=out iset=I1 prefix14_class=9955
cmp P1, P0
mov S1, P0
cmovl P0, P1
cmovge S1, P1
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
cmp S1, P3
mov S0, S1
cmovg S1, P3
cmovg P3, S0
cmovge S0, S1
mov P3, P2
