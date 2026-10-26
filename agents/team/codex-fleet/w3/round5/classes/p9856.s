# n=5 model=out iset=I1 prefix14_class=9856
mov S1, P2
cmp P3, P2
cmovge S1, P3
cmovle P2, P3
cmp P1, P0
cmovge P3, P0
cmovg P0, P1
mov S0, S1
cmovg P1, P3
cmp P0, S0
cmovl S1, P0
cmovl P0, S0
mov P0, S1
cmp P1, P2
