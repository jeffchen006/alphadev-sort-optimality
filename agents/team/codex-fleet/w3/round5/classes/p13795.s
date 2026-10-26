# n=5 model=out iset=I1 prefix14_class=13795
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmovg P0, S2
mov S1, P0
mov S0, P2
cmp P2, P1
cmovge S0, P1
cmovl P2, P1
cmp P2, S1
cmovle S1, P2
cmovge P0, P2
mov P0, P3
cmp P3, S0
