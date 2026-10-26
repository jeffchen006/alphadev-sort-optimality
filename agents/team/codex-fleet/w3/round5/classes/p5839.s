# n=5 model=out iset=I1 prefix14_class=5839
cmp P2, P3
mov S2, P3
cmovle S2, P2
cmovge P3, P2
mov P2, P1
cmp P2, P0
cmovle P2, P0
cmovl P0, P1
cmp S2, P0
mov P1, S2
cmovl S2, P0
cmovg P1, P0
cmp P3, P2
cmovle P0, P3
