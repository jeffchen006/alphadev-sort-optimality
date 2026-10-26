# n=5 model=out iset=I1 prefix14_class=3048
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovl S1, P2
mov P2, P3
cmp P0, P2
cmovle P2, P0
cmovle P0, P3
mov P3, P1
cmp P2, P1
cmovge P1, P2
cmovg P2, P3
cmp S1, P0
cmovge P2, S1
