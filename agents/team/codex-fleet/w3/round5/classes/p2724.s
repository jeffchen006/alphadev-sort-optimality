# n=5 model=out iset=I1 prefix14_class=2724
mov S1, P1
cmp S1, P0
cmovl S1, P0
cmovge P1, P0
mov P0, P2
cmp P0, P3
cmovge P0, P3
cmovl P2, P3
cmovg P3, P2
cmp S1, P2
cmovl P2, S1
cmovg P3, S1
mov S1, P0
cmp P0, P1
