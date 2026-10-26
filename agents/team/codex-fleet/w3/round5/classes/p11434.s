# n=5 model=out iset=I1 prefix14_class=11434
mov S0, P1
mov S1, P2
cmp P2, P3
cmovle S1, P3
cmovge P2, P3
cmp P1, P0
cmovg P1, P0
mov S2, P1
cmovl S0, P0
cmp P2, S2
cmovle S2, P2
cmovge P1, P2
cmp S1, S0
cmovl P0, S1
