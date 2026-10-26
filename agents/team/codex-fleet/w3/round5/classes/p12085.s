# n=5 model=out iset=I1 prefix14_class=12085
mov S0, P3
mov S1, P0
cmp P0, P1
cmovge P0, P1
cmovg P1, S1
cmp P2, S0
cmovg P3, P2
cmovge P2, S0
cmp P0, P2
cmovl S1, P2
cmovle P2, P0
cmovl P0, S1
cmp P1, P3
cmovge S1, P0
