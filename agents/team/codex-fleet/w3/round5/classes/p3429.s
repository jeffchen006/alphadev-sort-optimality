# n=5 model=out iset=I1 prefix14_class=3429
cmp P2, P3
mov S0, P3
cmovg S0, P2
cmovle P3, P2
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovge P0, S1
mov P2, P3
cmp P0, P3
cmovl P2, P0
mov P2, S0
cmovg P3, P0
cmp P1, P2
