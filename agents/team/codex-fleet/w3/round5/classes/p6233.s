# n=5 model=out iset=I1 prefix14_class=6233
cmp P0, P2
cmovle S1, P0
cmovge S1, P2
mov S2, P1
cmovl P0, P2
cmp P3, S2
cmovg P1, P3
cmovg P3, S2
mov P2, S1
cmp P0, P1
cmovle S0, P0
cmovge S0, P1
cmovge P1, P0
cmovge P0, S0
