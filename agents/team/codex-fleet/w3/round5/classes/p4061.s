# n=5 model=out iset=I1 prefix14_class=4061
cmp P2, P3
mov S0, P1
cmovge S1, P2
cmovg P2, P3
cmovge P3, S1
cmp P0, P1
cmovle S0, P0
mov S2, S0
cmovg P1, P0
cmp P2, S0
mov P0, P3
cmovl S0, P2
cmovg S2, P2
cmp P0, P1
