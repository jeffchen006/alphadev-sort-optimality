# n=5 model=out iset=I1 prefix14_class=7524
mov S0, P0
mov S1, P3
cmp P2, P0
cmovl S0, P2
cmovg P0, P2
cmp P1, P3
cmovg P3, P1
cmovge P1, S1
mov S2, S0
cmp S0, P1
cmovl S2, P1
cmovle P1, S0
cmp P0, P3
cmovl P1, P0
