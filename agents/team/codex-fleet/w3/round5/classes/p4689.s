# n=5 model=out iset=I1 prefix14_class=4689
mov S0, P0
cmp P2, S0
cmovle S0, P2
mov S1, P1
cmovge P0, P2
cmp S1, P3
cmovg P1, P3
cmovl S1, P3
mov P2, S0
cmp P0, S1
cmovg S2, S1
cmovge S1, P0
cmovg P0, S2
cmp P2, P1
