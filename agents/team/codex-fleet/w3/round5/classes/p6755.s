# n=5 model=out iset=I1 prefix14_class=6755
mov S0, P1
mov S2, P2
cmp P1, P0
cmovge P1, P0
cmovl S0, P0
cmp S2, P3
cmovge P2, P3
cmovle S2, P3
cmp S0, S2
cmovge P3, S0
cmovge S0, S2
cmovg S2, P3
cmp P1, P2
mov S1, S0
