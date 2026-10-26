# n=5 model=out iset=I1 prefix14_class=3583
cmp P1, P2
mov S0, P1
cmovl P1, P2
mov S2, P0
cmovl P2, S0
cmp P3, P0
cmovge S2, P3
mov S1, P1
cmovl P0, P3
cmp P0, P2
cmovg S0, P2
cmovle S0, P0
cmovge P2, P0
mov S0, P2
