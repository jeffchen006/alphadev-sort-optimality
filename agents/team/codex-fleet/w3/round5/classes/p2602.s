# n=5 model=out iset=I1 prefix14_class=2602
cmp P3, P2
cmovg S0, P2
cmovge P2, P3
cmovg P3, S0
mov S0, P0
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
cmp S0, P2
cmovl S2, S0
cmovge S2, P2
cmovle S0, P2
cmp P1, P3
cmovge P2, P3
