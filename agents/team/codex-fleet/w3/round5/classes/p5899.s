# n=5 model=out iset=I1 prefix14_class=5899
mov S2, P0
cmp P3, P1
cmovge S0, P1
cmovg P1, P3
cmovge P3, S0
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmp P2, P1
mov S1, P2
cmovle S1, P1
mov P0, S2
cmovl P1, P2
mov S1, P1
