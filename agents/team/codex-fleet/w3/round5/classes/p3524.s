# n=5 model=out iset=I1 prefix14_class=3524
mov S1, P1
cmp P1, P3
cmovge P1, P3
cmovg P3, S1
mov S0, P0
cmovge S1, P1
cmp P0, P2
cmovle S0, P2
cmovle P2, P0
cmp P2, P1
cmovl S1, P2
cmovge P1, P2
cmp P3, S0
cmovge S1, S0
