# n=5 model=out iset=I1 prefix14_class=4428
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovge P1, P3
cmp P0, P2
cmovge S1, P2
cmovl S1, P0
cmovg P2, P0
cmp P2, S2
cmovle P0, S2
cmovle S2, P2
cmovle P2, P0
mov P2, P1
cmp P1, S1
