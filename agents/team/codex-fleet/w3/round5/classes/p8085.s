# n=5 model=out iset=I1 prefix14_class=8085
mov S1, P2
cmp P1, P2
cmovge P2, P1
cmovg P1, S1
cmp P3, P0
cmovge S0, P3
cmovge P3, P0
cmovg P0, S0
cmp P1, P3
mov S1, P3
cmovl P3, P1
cmovge S1, P1
cmp P0, P2
cmovle S2, P2
