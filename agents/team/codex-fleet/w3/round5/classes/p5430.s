# n=5 model=out iset=I1 prefix14_class=5430
mov S0, P3
cmp P0, P3
cmovg P3, P0
cmovg P0, S0
cmp P2, P1
mov S0, P2
cmovl P2, P1
cmovge S0, P1
cmp S0, P0
cmovg S2, P0
cmovg P0, S0
cmovle S2, S0
cmp P3, P2
cmovge P1, P2
