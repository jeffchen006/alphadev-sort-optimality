# n=5 model=out iset=I1 prefix14_class=10871
mov S0, P3
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovge P2, S1
cmp P1, P3
cmovge P3, P1
cmovl S0, P1
cmp P3, P2
cmovge P1, P3
cmovl P1, P2
cmovle P2, P3
cmp P0, S0
cmovl P3, S0
