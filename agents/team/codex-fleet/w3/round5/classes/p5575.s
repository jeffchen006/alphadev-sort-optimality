# n=5 model=out iset=I1 prefix14_class=5575
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovge S0, P1
cmovg P1, P3
mov S1, P0
cmp S1, P2
cmovl P0, P2
cmovg S1, P2
cmp P1, S1
cmovg P3, S1
cmovge S1, P1
cmp S0, P0
cmovge P3, S0
