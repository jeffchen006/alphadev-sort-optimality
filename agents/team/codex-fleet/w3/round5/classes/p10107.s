# n=5 model=out iset=I1 prefix14_class=10107
cmp P2, P0
cmovge S0, P0
mov S2, P1
cmovge P0, P2
cmovg P2, S0
cmovle S0, P2
cmp P1, P3
cmovge P1, P3
cmovge P3, S2
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, S0
