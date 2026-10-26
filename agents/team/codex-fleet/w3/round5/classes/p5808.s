# n=5 model=out iset=I1 prefix14_class=5808
mov S2, P3
cmp P1, P3
cmovl S2, P1
cmovge P3, P1
cmp P0, P2
cmovle S0, P0
cmovge S0, P2
cmovg P2, P0
mov S1, S0
cmp S2, S1
cmovg S0, S2
cmovg S2, S1
mov P1, S0
mov S2, P3
