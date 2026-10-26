# n=5 model=out iset=I1 prefix14_class=2256
cmp P3, P0
cmovge S2, P3
cmovle S2, P0
cmovge P3, P0
mov P0, P2
cmp P1, P2
cmovge P0, P1
cmovge P1, P2
cmovg P2, P0
cmp P2, S2
cmovle P2, S2
cmovl S2, P0
mov P2, P1
cmp P1, P3
