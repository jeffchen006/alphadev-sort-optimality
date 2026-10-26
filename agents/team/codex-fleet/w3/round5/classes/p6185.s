# n=5 model=out iset=I1 prefix14_class=6185
mov S0, P2
cmp P3, S0
cmovl P2, P3
mov S2, P1
cmovl P3, S0
cmp P0, S2
cmovge S2, P0
cmovl P1, P0
cmp P3, S2
cmovle S0, P3
cmovl P3, S2
mov P0, P1
cmovle S2, S0
cmp P0, P2
