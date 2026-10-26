# n=5 model=out iset=I1 prefix14_class=5745
cmp P1, P0
cmovge S1, P0
cmovg P0, P1
cmovge P1, S1
cmp P2, P3
cmovle S1, P3
cmovg S1, P2
cmovge P2, P3
cmp P1, P2
mov S0, P2
cmovl S0, P1
cmovge P2, P1
cmp P0, S1
cmovge S0, P0
