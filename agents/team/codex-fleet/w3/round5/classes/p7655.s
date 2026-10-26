# n=5 model=out iset=I1 prefix14_class=7655
mov S2, P0
cmp P2, P0
cmovl S2, P2
cmovg P0, P2
mov S1, P3
mov S0, S2
cmp P1, S1
cmovge P3, P1
cmovl S1, P1
cmp S1, S0
cmovg S2, S1
cmovl S0, S1
cmp P3, P0
cmovle S0, P3
