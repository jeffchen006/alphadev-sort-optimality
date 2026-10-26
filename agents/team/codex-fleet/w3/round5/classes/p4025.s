# n=5 model=out iset=I1 prefix14_class=4025
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
mov S1, P0
cmp P3, S1
cmovl S1, P3
cmovge P0, P3
mov P3, S1
cmp P1, S1
cmovge P3, P1
cmovle S1, P1
cmp P0, P2
cmovle S2, P2
