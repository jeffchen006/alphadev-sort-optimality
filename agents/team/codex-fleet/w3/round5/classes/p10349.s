# n=5 model=out iset=I1 prefix14_class=10349
mov S0, P3
cmp P0, P3
cmovl P3, P0
cmovl P0, S0
cmp P1, P2
cmovg S1, P2
cmovge P2, P1
cmovg P1, S1
mov S2, P0
cmp P2, P0
cmovge S2, P2
cmovl P0, P2
cmp P3, P1
cmovle S2, P3
