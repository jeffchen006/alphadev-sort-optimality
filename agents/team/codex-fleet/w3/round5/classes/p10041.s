# n=5 model=out iset=I1 prefix14_class=10041
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
mov S0, P1
cmovg P2, S2
cmp P1, P3
cmovl S0, P3
cmovge P1, P3
cmp P2, S0
cmovg S1, P2
cmovle S1, S0
cmovge P2, S0
cmovle S0, P2
mov S1, P0
