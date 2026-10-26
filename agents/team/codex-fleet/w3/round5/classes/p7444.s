# n=5 model=out iset=I1 prefix14_class=7444
cmp P2, P0
cmovge S0, P2
mov S1, P1
cmovl S0, P0
cmovge P2, P0
cmp S1, P3
mov P0, P2
cmovg S1, P3
cmovg P3, P1
cmp P0, S1
cmovle S2, S0
cmovge P0, S1
cmovge S1, P2
cmp P3, S0
