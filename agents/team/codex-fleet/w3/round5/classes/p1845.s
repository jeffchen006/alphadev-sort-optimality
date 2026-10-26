# n=5 model=out iset=I1 prefix14_class=1845
cmp P2, P0
cmovge S1, P2
mov S0, P1
cmovle S1, P0
cmovle P0, P2
mov P2, S1
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmp P2, S0
cmovge S1, S0
cmovl P2, S0
mov P2, P3
cmovl S0, S1
