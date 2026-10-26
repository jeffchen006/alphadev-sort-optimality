# n=5 model=out iset=I1 prefix14_class=13332
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmovg P1, S0
cmp P2, P0
mov S2, P3
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P0, S2
cmovle S2, P0
cmovg P3, P0
cmp P1, P2
cmovge S1, P2
