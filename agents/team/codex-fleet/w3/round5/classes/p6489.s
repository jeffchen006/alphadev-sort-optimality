# n=5 model=out iset=I1 prefix14_class=6489
cmp P3, P1
cmovg S1, P1
mov S2, P2
cmovg P1, P3
cmovle S1, P3
cmp P0, P2
cmovg S2, P0
cmovge P0, P2
mov P2, S1
mov S0, S2
cmp S0, P1
cmovl S0, P1
cmovg S2, P1
mov S0, S2
