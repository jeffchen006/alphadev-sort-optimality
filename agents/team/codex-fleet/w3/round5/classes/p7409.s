# n=5 model=out iset=I1 prefix14_class=7409
cmp P0, P2
mov S0, P0
cmovl S0, P2
cmovge P0, P2
mov S2, P1
cmp S2, P3
mov P2, P0
cmovg S2, P3
cmovge P3, P1
cmp P2, S2
cmovge P2, S2
cmovl P0, S2
cmp S0, P3
cmovle S1, P3
