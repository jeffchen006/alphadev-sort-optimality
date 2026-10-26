# n=5 model=out iset=I1 prefix14_class=5805
cmp P1, P0
mov S0, P1
cmovg P1, P0
mov S2, P3
cmovge P0, S0
cmovg S0, P1
cmp S2, P2
cmovg S2, P2
cmovge P2, P3
cmp S2, P1
cmovg P1, S2
cmovl S0, S2
mov S0, P1
cmp P2, P0
