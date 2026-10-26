# n=5 model=out iset=I1 prefix14_class=2784
cmp P2, P1
mov S0, P3
cmovge S1, P2
cmovge P2, P1
cmovg P1, S1
cmp P3, P0
mov S2, P1
cmovge P3, P0
cmovl S0, P0
cmp S2, S0
cmovge P1, S0
cmovge S0, S2
cmp P2, P3
cmovle S1, P2
