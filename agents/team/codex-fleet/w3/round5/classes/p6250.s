# n=5 model=out iset=I1 prefix14_class=6250
mov S0, P0
cmp P2, P0
mov S2, P1
cmovge S0, P2
cmovge P2, P0
cmp P3, S2
cmovg P1, P3
mov S1, S0
cmovl S2, P3
cmp P1, S0
cmovg S0, P1
cmovge P1, S1
cmp P2, S2
cmovle S0, S2
