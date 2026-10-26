# n=5 model=out iset=I1 prefix14_class=5161
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
mov S0, P2
cmp P1, S0
cmovl P2, P1
mov S2, P2
cmovle P1, S0
cmp P2, P3
cmovg P2, P3
cmovg P3, S2
cmp P1, P0
cmovge S0, P0
