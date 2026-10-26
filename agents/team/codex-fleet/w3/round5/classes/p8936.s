# n=5 model=out iset=I1 prefix14_class=8936
mov S0, P1
cmp S0, P0
cmovge P1, P0
cmovl S0, P0
mov P0, P2
cmp P3, P2
cmovge P2, P3
mov S2, P2
cmovg P3, P0
cmp S0, P2
cmovle S2, S0
cmovle S0, P2
cmp P3, P1
cmovg P0, P3
