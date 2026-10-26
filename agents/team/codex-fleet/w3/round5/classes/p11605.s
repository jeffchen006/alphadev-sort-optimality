# n=5 model=out iset=I1 prefix14_class=11605
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmovge P2, S1
cmp P0, P1
cmovge S2, P0
cmovl S2, P1
cmovle P1, P0
cmp P2, S2
mov P0, P2
cmovge P2, S2
cmovge S2, P0
cmp P3, P1
cmovle S1, P1
