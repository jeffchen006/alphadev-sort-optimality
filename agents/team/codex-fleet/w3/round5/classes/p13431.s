# n=5 model=out iset=I1 prefix14_class=13431
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovl S1, P0
mov P0, S1
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmp P3, P2
mov P0, P3
