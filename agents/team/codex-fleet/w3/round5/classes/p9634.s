# n=5 model=out iset=I1 prefix14_class=9634
cmp P1, P3
mov S1, P1
cmovl S1, P3
cmovge P1, P3
mov P3, P2
cmp P0, P3
cmovge P3, P0
cmovge P0, P2
cmp P3, S1
cmovg P2, P3
cmovg P3, S1
cmovle P2, S1
cmp P0, P1
mov P2, P0
