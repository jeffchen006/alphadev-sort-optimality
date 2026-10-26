# n=5 model=out iset=I1 prefix14_class=4681
mov S1, P2
cmp P0, S1
mov S2, P3
cmovle S1, P0
cmovge P2, P0
mov S0, S1
cmp S2, P1
cmovl S2, P1
cmovg P3, P1
mov P1, S2
cmp S2, P2
cmovl S2, P2
cmovge P1, P2
mov S2, P1
