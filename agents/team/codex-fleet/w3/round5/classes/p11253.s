# n=5 model=out iset=I1 prefix14_class=11253
cmp P3, P0
cmovle S1, P0
cmovge S1, P3
cmovg P3, P0
cmp P1, P2
mov S0, P2
cmovge S0, P1
cmovge P1, P2
mov S2, S0
cmp S2, S1
cmovg S0, S1
cmovl S2, S1
cmovle S1, S0
mov S2, P3
