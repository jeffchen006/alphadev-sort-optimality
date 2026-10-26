# n=5 model=out iset=I1 prefix14_class=5903
cmp P1, P2
mov S0, P1
cmovl S0, P2
cmovge P1, P2
cmp P0, P3
cmovge S1, P3
cmovge P3, P0
cmovge P0, S1
cmp P3, S0
cmovle P2, P3
mov S2, P0
cmovle P3, S0
cmovl S0, P2
cmp S2, P1
