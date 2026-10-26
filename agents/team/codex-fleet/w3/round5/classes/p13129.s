# n=5 model=out iset=I1 prefix14_class=13129
cmp P2, P0
mov S0, P0
cmovg S0, P2
cmovge P2, P0
mov S2, P2
mov S1, P1
cmp S1, P3
cmovl P1, P3
cmovle P3, S1
cmp P2, P3
cmovg P2, P3
cmovge P3, S2
cmp S0, P1
cmovl S2, P3
