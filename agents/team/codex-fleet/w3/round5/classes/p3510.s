# n=5 model=out iset=I1 prefix14_class=3510
mov S2, P3
cmp P0, P1
cmovge S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P2, P3
cmovl P3, P2
cmovl P2, S2
mov S1, P3
cmp P3, P0
cmovle S1, P0
mov S2, P2
cmovg P3, P0
cmp P1, S2
