# n=5 model=out iset=I1 prefix14_class=2030
mov S2, P1
cmp P0, S2
cmovge P1, P0
cmovge P0, S2
mov S1, P2
mov S2, P1
cmp P3, P2
cmovg P2, P3
cmovle S1, P3
cmp P2, S2
cmovge P1, P2
cmovl S2, P2
cmp S1, P0
cmovg S0, P0
