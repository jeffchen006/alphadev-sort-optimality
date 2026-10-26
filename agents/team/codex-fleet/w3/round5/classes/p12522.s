# n=5 model=out iset=I1 prefix14_class=12522
mov S2, P1
mov S0, P2
cmp P3, S0
cmovle S0, P3
cmovl P3, P2
cmp P1, P0
cmovg S2, P0
cmovge P0, P1
cmp S2, S0
mov S1, S0
cmovge S1, S2
cmovge S2, S0
cmp P0, P3
cmovl S0, P0
