# n=5 model=out iset=I1 prefix14_class=10822
cmp P0, P1
mov S1, P1
cmovg P1, P0
mov S2, P1
cmovle S1, P0
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
cmovl S0, P3
cmp P1, S0
cmovl P1, S0
cmovge S2, S0
mov P1, S1
cmovle S0, S2
