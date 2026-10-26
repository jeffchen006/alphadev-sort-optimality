# n=5 model=out iset=I1 prefix14_class=9496
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
cmovge S2, P2
mov P2, P1
cmp P0, P1
cmovg P1, P0
cmovge P0, P2
cmovl P2, P0
cmp P0, P3
cmovge P2, P3
cmovl P0, P3
cmp P1, S2
cmovle P2, S2
