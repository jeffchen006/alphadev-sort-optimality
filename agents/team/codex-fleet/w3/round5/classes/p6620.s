# n=5 model=out iset=I1 prefix14_class=6620
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovl S0, P0
cmp P3, P1
mov P0, P3
cmovl P3, P1
cmovg P0, P1
mov P1, P2
cmp P3, P1
cmovg P2, P3
cmovge P3, P1
cmp S0, P0
cmovle S2, P0
