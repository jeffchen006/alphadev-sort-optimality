# n=5 model=out iset=I1 prefix14_class=545
mov S0, P1
cmp P2, S0
cmovge P1, P2
mov S2, P0
cmovl S0, P2
cmp S2, P3
cmovg S2, P3
cmovg P3, P0
mov P0, S0
cmp S2, S0
cmovge P0, S2
cmovg S2, S0
mov S2, P1
cmp P3, S2
