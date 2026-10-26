# n=5 model=out iset=I1 prefix14_class=9007
mov S1, P3
cmp P1, P0
cmovge S0, P1
cmovg P1, P0
cmovle S0, P0
cmp P2, P3
cmovl S1, P2
cmovle P2, P3
cmp S0, P2
cmovge P3, P2
cmovge P2, S0
cmovg S0, P3
cmp S1, P1
cmovge S2, S1
