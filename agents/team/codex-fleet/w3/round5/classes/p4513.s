# n=5 model=out iset=I1 prefix14_class=4513
cmp P1, P3
cmovge S0, P1
mov S1, P0
cmovge P1, P3
cmovl S0, P3
cmp S1, P2
cmovge P0, P2
cmovg P2, S1
cmovle S1, P2
cmp P2, S0
cmovg P2, S0
cmovg S0, S1
cmp P1, P0
cmovle S1, P1
