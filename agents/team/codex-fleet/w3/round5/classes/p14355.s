# n=5 model=out iset=I1 prefix14_class=14355
cmp P2, P3
cmovg S0, P2
cmovg P2, P3
cmovle S0, P3
cmp P1, P0
cmovl P3, P1
cmovl P1, P0
mov S2, P2
cmovl P0, P3
cmp P0, S2
cmovge P2, P0
cmovge P0, S2
mov S1, S0
cmp P1, S1
