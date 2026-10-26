# n=5 model=out iset=I1 prefix14_class=9292
cmp P0, P1
cmovle S0, P0
cmovge S0, P1
cmovge P1, P0
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
cmovl P2, S1
mov S2, S0
cmp P3, S0
cmovle S0, P3
cmovge S2, P3
cmp P2, P1
mov P3, P2
