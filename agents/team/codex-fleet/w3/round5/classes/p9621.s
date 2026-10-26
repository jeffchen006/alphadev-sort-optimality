# n=5 model=out iset=I1 prefix14_class=9621
cmp P0, P3
mov S2, P1
cmovge S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P1, P2
cmovle S2, P2
mov S0, P3
cmovge P1, P2
cmp S0, S2
cmovg P3, S2
cmovg S2, S0
cmp P1, P0
cmovl S2, P1
