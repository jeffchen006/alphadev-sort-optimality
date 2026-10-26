# n=5 model=out iset=I1 prefix14_class=12171
cmp P1, P3
mov S0, P3
mov S1, P0
cmovg P3, P1
cmovge P1, S0
cmp P0, P2
cmovge P0, P2
cmovl S1, P2
cmp P0, P1
cmovge P2, P0
cmovge P0, P1
cmovg P1, P2
cmp P3, S1
mov P0, P3
