# n=5 model=out iset=I1 prefix14_class=5432
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
mov S0, P3
cmp P3, P0
cmovle S0, P0
cmovge P3, P0
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovl S1, P3
cmp S0, P2
cmovle P0, S0
