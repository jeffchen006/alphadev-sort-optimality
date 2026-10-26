# n=5 model=out iset=I1 prefix14_class=8608
mov S0, P3
cmp P1, P0
mov S1, P0
cmovl P0, P1
cmovg S1, P1
cmp P2, S0
cmovg P3, P2
cmovg P2, S0
mov S0, P2
cmp P3, S1
cmovge P1, P3
cmovge P3, S1
cmovge S1, P1
cmp S0, P0
