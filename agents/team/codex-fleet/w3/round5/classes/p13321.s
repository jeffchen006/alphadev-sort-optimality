# n=5 model=out iset=I1 prefix14_class=13321
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P0, P3
mov S1, P2
cmovle S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P3, S1
cmovl P2, P3
cmovg S1, P3
cmp P1, P0
cmovge P2, P0
