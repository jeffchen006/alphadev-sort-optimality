# n=5 model=out iset=I1 prefix14_class=1898
cmp P1, P0
mov S0, P0
cmovl P0, P1
cmovl P1, S0
mov S1, P3
cmp P2, S1
cmovge P3, P2
cmovle S1, P2
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovl P1, P3
mov P1, P0
mov S2, S0
