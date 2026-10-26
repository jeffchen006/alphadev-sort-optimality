# n=5 model=out iset=I1 prefix14_class=3075
cmp P3, P2
mov S2, P2
cmovge P2, P3
cmovg P3, S2
cmp P0, P1
cmovle S0, P0
cmovg S0, P1
cmovl P0, P1
mov S1, P0
cmp S0, P3
cmovge P1, S0
cmovg S0, P3
cmovg P3, P1
mov S0, P3
