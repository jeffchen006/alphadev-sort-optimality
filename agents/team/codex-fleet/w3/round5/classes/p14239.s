# n=5 model=out iset=I1 prefix14_class=14239
cmp P1, P3
cmovge S0, P1
cmovg P1, P3
cmovge P3, S0
cmp P0, P2
cmovl S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P3, P0
mov S1, P3
cmovg S1, P0
cmovge P0, P3
cmp P2, P1
mov P3, S1
