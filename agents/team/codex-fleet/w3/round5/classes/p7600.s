# n=5 model=out iset=I1 prefix14_class=7600
cmp P1, P0
mov S2, P3
cmovle S0, P1
cmovl P1, P0
cmovl P0, S0
cmp P2, S2
cmovg P3, P2
cmovge P2, S2
cmp P0, P2
mov S2, P2
cmovge S2, P0
cmovl P2, P0
mov P0, P1
cmp P3, P0
