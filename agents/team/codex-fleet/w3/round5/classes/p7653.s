# n=5 model=out iset=I1 prefix14_class=7653
mov S1, P1
cmp P0, P1
mov S0, P2
cmovge P1, P0
cmovl S1, P0
mov S2, S1
cmp P3, S0
cmovge S0, P3
cmovle P2, P3
cmp P2, S2
cmovle S1, P2
cmovg S2, P2
mov S1, S0
cmp P1, S0
