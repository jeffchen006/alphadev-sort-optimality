# n=5 model=out iset=I1 prefix14_class=13702
mov S2, P2
cmp S2, P1
cmovg P2, P1
cmovle S2, P1
mov S0, P2
cmp P0, P3
cmovge P1, P3
cmovge P3, P0
cmovg P0, P1
cmp P0, P2
cmovl S0, P0
cmovge P2, P0
mov S0, P3
cmp S2, P3
