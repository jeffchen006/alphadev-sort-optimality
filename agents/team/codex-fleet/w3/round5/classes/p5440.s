# n=5 model=out iset=I1 prefix14_class=5440
cmp P2, P1
mov S1, P3
cmovg S0, P1
cmovle S0, P2
cmovle P2, P1
cmp P0, P3
cmovge P3, P0
cmovg P0, S1
cmp P0, S0
cmovle P1, S0
cmovge P1, P0
cmovl S0, P0
cmp P2, P3
cmovl S2, P2
