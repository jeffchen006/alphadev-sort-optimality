# n=5 model=out iset=I1 prefix14_class=6944
cmp P3, P2
cmovle S1, P2
cmovg S1, P3
cmovge P3, P2
cmp P0, P1
mov S2, P1
cmovg P1, P0
mov S0, S1
cmovl S2, P0
cmp S0, P1
cmovge S0, P1
cmovge P1, S1
cmp P3, S2
cmovg S1, S0
