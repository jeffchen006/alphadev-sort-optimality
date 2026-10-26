# n=5 model=out iset=I1 prefix14_class=11252
mov S2, P0
mov S0, P1
cmp P2, S0
cmovg S0, P2
cmovge P2, P1
cmp S2, P3
cmovle S2, P3
cmovge P0, P3
cmp S0, S2
mov S1, S0
cmovg S0, S2
cmovl S1, S2
cmp P0, P2
cmovge P3, P2
