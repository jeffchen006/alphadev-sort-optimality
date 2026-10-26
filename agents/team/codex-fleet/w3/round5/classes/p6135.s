# n=5 model=out iset=I1 prefix14_class=6135
cmp P1, P2
mov S0, P1
cmovl P1, P2
cmovl P2, S0
mov S2, P3
cmp P0, P3
cmovg P3, P0
cmovge P0, S2
cmp P1, P3
cmovg S1, P1
cmovg P1, P3
cmovle S1, P3
cmp P0, P2
cmovge S0, P2
