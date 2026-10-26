# n=5 model=out iset=I1 prefix14_class=12582
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
mov S2, P3
cmovle S0, P1
cmp P0, P2
cmovl P1, P2
cmovl P2, P0
cmovl P0, P1
cmp P2, S2
cmovle P3, P2
cmovle P2, S2
mov P3, P0
cmp P0, S0
