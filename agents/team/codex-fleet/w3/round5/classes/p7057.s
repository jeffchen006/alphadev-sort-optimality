# n=5 model=out iset=I1 prefix14_class=7057
cmp P0, P2
mov S0, P2
cmovge S0, P0
mov S1, P1
cmovg P0, P2
cmp P1, P3
cmovge P1, P3
cmovge P3, S1
cmp P1, P0
cmovl S2, P1
cmovle P1, P0
cmovl P0, S2
cmp S0, P3
mov P2, S0
