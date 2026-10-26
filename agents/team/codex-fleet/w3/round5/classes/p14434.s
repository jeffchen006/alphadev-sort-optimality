# n=5 model=out iset=I1 prefix14_class=14434
cmp P2, P0
mov S1, P3
cmovge S2, P0
cmovl S2, P2
cmovle P2, P0
cmp P1, S1
cmovl P3, P1
cmovg S1, P1
cmp S2, P3
cmovge P1, S2
cmovge S2, P3
cmovge P3, P1
cmp P2, S1
mov S2, P2
