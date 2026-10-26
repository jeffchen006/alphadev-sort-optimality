# n=5 model=out iset=I1 prefix14_class=931
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmovge S2, P0
cmp P3, P1
mov S1, P3
cmovge P3, P1
cmovge P1, S1
cmp P1, S2
cmovl S1, S2
cmovge S1, P1
cmovge P1, S2
cmp P3, P2
mov S2, P1
