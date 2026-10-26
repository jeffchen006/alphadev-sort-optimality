# n=5 model=out iset=I1 prefix14_class=2799
cmp P1, P2
cmovl S1, P1
cmovge S1, P2
cmovge P2, P1
mov S2, P0
cmp P3, S2
cmovle S2, P3
cmovle P3, P0
cmp P3, P2
cmovge P0, P2
cmovg P2, P3
mov P2, S2
cmovge P3, P0
cmp P2, S1
