# n=5 model=out iset=I1 prefix14_class=3406
cmp P1, P3
mov S1, P3
cmovg P3, P1
mov S2, P2
cmovl S1, P1
cmp P2, P0
cmovl S2, P0
cmovle P0, P2
mov S0, P0
cmp S1, P0
cmovg S0, S1
cmovl P0, S1
cmp S2, P3
cmovge P2, P3
