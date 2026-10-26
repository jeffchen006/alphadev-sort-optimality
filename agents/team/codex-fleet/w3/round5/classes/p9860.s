# n=5 model=out iset=I1 prefix14_class=9860
cmp P2, P1
mov S2, P1
cmovle S2, P2
cmovg P1, P2
mov S0, P1
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P0, P1
cmovl P1, P0
cmovl P0, S0
cmp P3, S2
mov P0, P1
