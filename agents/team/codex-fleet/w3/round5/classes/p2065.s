# n=5 model=out iset=I1 prefix14_class=2065
cmp P0, P1
cmovle S0, P1
cmovge S0, P0
cmovl P1, P0
mov S1, P2
cmp P2, P3
cmovge P2, P3
cmovg P3, S1
cmp P3, S0
cmovl S2, P3
cmovle P3, S0
cmovge S2, S0
mov P0, P2
mov S1, S2
