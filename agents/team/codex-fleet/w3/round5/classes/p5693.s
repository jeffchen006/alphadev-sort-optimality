# n=5 model=out iset=I1 prefix14_class=5693
mov S1, P1
cmp P1, P0
cmovge P1, P0
cmovg P0, S1
mov S0, P2
cmp S0, P3
cmovg S0, P3
mov S1, S0
cmovge P3, P2
cmp P1, S1
cmovl S1, P1
cmovle P1, S0
cmp P0, P3
cmovge P2, P0
