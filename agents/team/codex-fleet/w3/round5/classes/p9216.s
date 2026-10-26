# n=5 model=out iset=I1 prefix14_class=9216
cmp P0, P3
cmovl S1, P3
cmovge S1, P0
cmovg P0, P3
cmp P2, P1
cmovle P3, P1
cmovg P3, P2
cmovle P1, P2
cmp P0, P1
mov P2, P0
cmovge P0, P1
cmovge P1, P2
cmp P3, S1
cmovge P2, S1
