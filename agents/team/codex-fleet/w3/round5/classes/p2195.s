# n=5 model=out iset=I1 prefix14_class=2195
cmp P0, P2
mov S0, P1
cmovge S1, P0
cmovg P0, P2
cmovl S1, P2
cmp P3, S0
cmovge P1, P3
mov S2, P1
cmovg P3, S0
cmp P1, S1
cmovle S2, S1
cmovle S1, P1
cmp P3, P0
cmovle S0, P3
