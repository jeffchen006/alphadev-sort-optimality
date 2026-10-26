# n=5 model=out iset=I1 prefix14_class=11419
mov S0, P1
cmp P0, S0
cmovle S0, P0
cmovl P0, P1
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
cmovg P3, S2
mov P1, P2
cmp P2, S0
cmovl P1, S0
cmovg P2, S0
mov P2, P3
cmp P2, P0
