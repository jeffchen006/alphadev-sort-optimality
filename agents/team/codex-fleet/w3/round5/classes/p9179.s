# n=5 model=out iset=I1 prefix14_class=9179
mov S0, P0
cmp P1, P0
cmovge P0, P1
mov S2, P2
cmovle S0, P1
cmp P3, S2
cmovl P2, P3
cmovl P3, S2
cmp P2, S0
cmovg S2, P2
cmovge P2, S0
cmovg S0, S2
mov S1, P3
cmp P0, S1
