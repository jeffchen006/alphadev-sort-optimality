# n=5 model=out iset=I1 prefix14_class=13467
mov S0, P0
cmp P1, S0
cmovge P0, P1
cmovle S0, P1
cmp P2, P3
mov S2, P3
cmovl S2, P2
cmovge P3, P2
mov S1, S0
cmp S0, S2
cmovge S1, S2
cmovg S2, S0
mov S0, S2
mov S1, P0
