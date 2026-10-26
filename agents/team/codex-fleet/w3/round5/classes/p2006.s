# n=5 model=out iset=I1 prefix14_class=2006
mov S1, P1
cmp P2, S1
cmovg P1, P2
cmovge P2, S1
mov S1, P3
cmp P3, P0
cmovge P3, P0
cmovl S1, P0
mov P0, S1
cmp P1, S1
cmovge P0, P1
cmovg P1, S1
cmovl S1, P1
cmp P3, P2
