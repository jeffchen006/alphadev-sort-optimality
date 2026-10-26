# n=5 model=out iset=I1 prefix14_class=1899
cmp P2, P0
mov S0, P0
cmovl P0, P2
cmovl P2, S0
mov S1, P3
cmp P1, S1
cmovge P3, P1
cmovle S1, P1
mov S0, P3
cmp P2, S0
cmovle S0, P2
cmovl P2, P3
mov P2, P0
mov S2, S0
