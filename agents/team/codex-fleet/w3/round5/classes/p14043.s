# n=5 model=out iset=I1 prefix14_class=14043
mov S1, P3
cmp P3, P0
cmovg P3, P0
cmovg P0, S1
cmp P2, P1
cmovge S0, P2
mov S2, P0
cmovge P2, P1
cmovg P1, S0
cmp P1, S2
cmovl P0, P1
cmovl P1, S2
cmovle S2, P0
cmp P2, P3
