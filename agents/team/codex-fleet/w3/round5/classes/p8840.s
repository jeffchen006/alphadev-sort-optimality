# n=5 model=out iset=I1 prefix14_class=8840
mov S0, P0
cmp P0, P3
mov S1, P1
cmovge S0, P3
cmovl P0, P3
cmp P2, S1
cmovl P1, P2
cmovle P2, S1
cmp P0, P2
mov P3, P1
cmovge S1, P2
cmovg P2, P0
cmovge P0, S1
cmp P3, S0
