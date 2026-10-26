# n=5 model=out iset=I1 prefix14_class=1479
mov S0, P2
mov S1, P0
cmp S1, P3
cmovl S1, P3
cmovg P0, P3
cmp S0, P1
cmovl P2, P1
cmovle P1, S0
cmp S1, P2
mov P3, P0
cmovg S2, P2
cmovge P2, S1
cmovg S1, S2
cmp P1, P0
