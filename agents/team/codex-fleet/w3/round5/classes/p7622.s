# n=5 model=out iset=I1 prefix14_class=7622
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P3, P1
cmovle S1, P3
cmovg S1, P1
cmovg P1, P3
mov S0, P2
cmp P2, S1
cmovg S0, S1
mov S0, P1
cmovge S1, P2
cmp P0, P1
