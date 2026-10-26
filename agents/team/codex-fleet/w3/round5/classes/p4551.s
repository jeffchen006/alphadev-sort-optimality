# n=5 model=out iset=I1 prefix14_class=4551
mov S2, P1
mov S1, P0
cmp P0, P2
cmovg P0, P2
cmovle S1, P2
cmp P1, P3
mov S0, S1
cmovl P1, P3
cmovge S2, P3
cmp P1, S0
cmovg P2, S2
cmovle S1, P1
cmovge S0, P1
cmp P0, S2
