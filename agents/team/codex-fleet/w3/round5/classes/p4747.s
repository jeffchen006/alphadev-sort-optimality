# n=5 model=out iset=I1 prefix14_class=4747
cmp P0, P2
cmovge S2, P0
cmovl S2, P2
cmovge P0, P2
mov P2, P1
cmp P3, P1
mov S1, P0
cmovg P1, P3
cmovge P3, P2
cmp P3, P0
cmovg P0, P3
mov S0, P0
cmovg P3, S1
mov P3, S2
