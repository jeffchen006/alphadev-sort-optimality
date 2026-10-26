# n=5 model=out iset=I1 prefix14_class=4694
mov S0, P2
mov S1, P0
cmp P1, S0
cmovle P2, P1
cmovg S0, P1
cmp S1, P3
cmovg P0, P3
cmovl S1, P3
cmp S1, S0
cmovge P3, S0
cmovge S0, S1
cmovge S1, P3
mov P1, P0
cmp P0, P2
